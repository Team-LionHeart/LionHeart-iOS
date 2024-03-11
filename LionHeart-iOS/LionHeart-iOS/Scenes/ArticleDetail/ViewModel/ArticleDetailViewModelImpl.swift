//
//  ArticleDetailViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/20/23.
//

import Foundation
import Combine

struct Article: Equatable {
    let blockTypes: [BlockTypeAppData]
    let isMarked: Bool
}

final class ArticleDetailViewModelImpl: ArticleDetailViewModel, ArticleDetailViewModelPresentable {
    
    private enum FlowType {
        case closeButtonTapped
        case expired
    }
    
    private var adaptor: ArticleDetailModalNavigation
    private let manager: ArticleDetailManager
    
    private let navigationSubject = PassthroughSubject<FlowType, Never>()
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    var isBookMarked: Bool?
    private var articleDatas: [BlockTypeAppData]?
    var articleId: Int?
    
    init(adaptor: ArticleDetailModalNavigation, manager: ArticleDetailManager) {
        self.adaptor = adaptor
        self.manager = manager
    }
    
    func transform(input: ArticleDetailViewModelInput) -> ArticleDetailViewModelOutput {
        
        errorSubject
            .sink { [weak self] error in
                self?.handleError(error)
                print(error.description)
            }
            .store(in: &cancelBag)
        
        navigationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] flow in
                guard let self else { return }
                switch flow {
                case .closeButtonTapped:
                    self.adaptor.closeButtonTapped()
                case .expired:
                    self.adaptor.checkTokenIsExpired()
                }
            }
            .store(in: &cancelBag)
        
        input.closeButtonTapped
            .sink { [weak self] _ in
                self?.navigationSubject.send(.closeButtonTapped)
            }
            .store(in: &cancelBag)
        
        
        let bookMark = input.bookmarkButtonTapped
            .flatMap { _ -> AnyPublisher<String, Never> in
                return Future<String, NetworkError> { promise in
                    Task {
                        do {
                            guard let isMarked = self.isBookMarked,
                                  let articleId = self.articleId
                            else { return }
                            
                            let requestStatus = !isMarked
                            
                            try await self.articleBookMark(articleId: articleId, isSelected: requestStatus)
                            
                            if requestStatus {
                                promise(.success(BookmarkCompleted.save.message))
                            } else {
                                promise(.success(BookmarkCompleted.delete.message))
                            }
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }.catch { error in
                    self.errorSubject.send(error)
                    return Just(BookmarkCompleted.failure.message)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        
        let articleBlockTypes = input.viewWillAppear
            .flatMap { _ -> AnyPublisher<Article, Never> in
                return Future<Article, NetworkError> { promise in
                    Task {
                        do {
                            guard let articleId = self.articleId else { return }
                            let articleBlocks = try await self.getArticleDetail(articleId: articleId)
                            let thumbnail = articleBlocks[0]
                            if case .thumbnail(let isMarked, _) = thumbnail {
                                self.isBookMarked = isMarked
                                promise(.success(Article(blockTypes: articleBlocks, isMarked: isMarked)))
                            }
                        } catch {
                            guard let error = error as? NetworkError else { return }
                            promise(.failure(error))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just(Article(blockTypes: [], isMarked: false))
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let scrollToTop = input.scrollToTopButtonTapped.eraseToAnyPublisher()
        
        return Output(articleDetail: articleBlockTypes, bookmarkCompleted: bookMark, scrollToTopButtonTapped: scrollToTop)
    }
    
}

// MARK: - Network

extension ArticleDetailViewModelImpl {
    private func getArticleDetail(articleId: Int) async throws -> [BlockTypeAppData] {
        return try await manager.getArticleDetail(articleId: articleId)
    }

    private func articleBookMark(articleId: Int, isSelected: Bool) async throws {
        let bookmarkRequest = BookmarkRequest(articleId: articleId, bookmarkRequestStatus: isSelected)
        try await manager.postBookmark(model: bookmarkRequest)
        isBookMarked = isSelected
    }
}

extension ArticleDetailViewModelImpl {
    func handleError(_ error: NetworkError) {
        if case .unAuthorizedError = error {
            self.navigationSubject.send(.expired)
        }
    }
}


extension ArticleDetailViewModelImpl {
    /// Article ID를 해당 메서드로 넘긴 후에 해당 VC를 present해주세요
    /// - Parameter id: articleId
    func setArticleId(id: Int) {
        self.articleId = id
    }
}
