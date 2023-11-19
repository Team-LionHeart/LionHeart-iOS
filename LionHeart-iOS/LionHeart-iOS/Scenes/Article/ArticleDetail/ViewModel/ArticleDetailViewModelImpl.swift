//
//  ArticleDetailViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/20/23.
//

import Foundation
import Combine

struct Article {
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
    
    private var cancelBag = Set<AnyCancellable>()
    
    private var isBookMarked: Bool?
//    {
//        didSet {
//            guard let isBookMarked else { return }
//            LHToast.show(message: isBookMarked ? "북마크가 추가되었습니다" : "북마크가 해제되었습니다")
//        }
//    }

    private var articleDatas: [BlockTypeAppData]?
//    {
//        didSet {
//            self.articleTableView.reloadData()
//            hideLoading()
//        }
//    }
    
    private var articleId: Int?
    
    init(adaptor: ArticleDetailModalNavigation, manager: ArticleDetailManager) {
        self.adaptor = adaptor
        self.manager = manager
    }
    
    func transform(input: ArticleDetailViewModelInput) -> ArticleDetailViewModelOutput {
        
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
        
        
        let articleBlockTypes = input.viewWillAppear
            .flatMap { _ -> AnyPublisher<Result<Article, NetworkError>, Never> in
                return Future<Result<Article, NetworkError>, NetworkError> { promise in
                    Task {
                        do {
                            guard let articleId = self.articleId else { return }
                            let articleBlocks = try await self.getArticleDetail(articleId: articleId)
                            let thumbnail = articleBlocks[0]
                            if case .thumbnail(let isMarked, _) = thumbnail {
                                self.isBookMarked = isMarked
                                promise(.success(.success(Article(blockTypes: articleBlocks, isMarked: isMarked))))
                            }
                        } catch {
                            guard let error = error as? NetworkError else { return }
                            self.handleError(error)
                        }
                    }
                }
                .catch { error in
                    return Just(.failure(error))
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        
        return Output(articleDetail: articleBlockTypes)
    }
    
}

// MARK: - Network

extension ArticleDetailViewModelImpl {
    private func getArticleDetail(articleId: Int) async throws -> [BlockTypeAppData] {
        return try await manager.getArticleDetail(articleId: articleId)
    }

    private func articleBookMark(articleId: Int, isSelected: Bool) {
        Task {
            do {
                let bookmarkRequest = BookmarkRequest(articleId: articleId, bookmarkRequestStatus: isSelected)
                try await manager.postBookmark(model: bookmarkRequest)

                isBookMarked = isSelected
            } catch {
                guard let error = error as? NetworkError else { return }
                self.handleError(error)
            }
        }

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
