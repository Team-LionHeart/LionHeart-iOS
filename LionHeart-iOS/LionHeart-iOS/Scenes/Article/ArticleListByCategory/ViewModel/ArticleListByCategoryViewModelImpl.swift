//
//  ArticleListByCategoryViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/20/23.
//

import Foundation
import Combine

final class ArticleListByCategoryViewModelImpl: ArticleListByCategoryViewModel & ArticleListByCategoryViewModelPresentable {
    
    private enum FlowType {
        case article(articleId: Int)
        case backButton
        case expire
    }
    
    private let navigator: ArticleListByCategoryNavigation
    private let manager: ArticleListByCategoryManager
    
    var categoryString: String?
    var articleListData: [ArticleDataByWeek]?
    
    private let navigationSubject = PassthroughSubject<FlowType, Never>()
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    init(navigator: ArticleListByCategoryNavigation, manager: ArticleListByCategoryManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    func transform(input: ArticleListByCategoryViewModelInput) -> ArticleListByCategoryViewModelOutput {
        
        errorSubject
            .sink { error in
                print(error)
            }
            .store(in: &cancelBag)
        
        navigationSubject
            .receive(on: RunLoop.main)
            .sink { flow in
                switch flow {
                case .article(let articleID):
                    self.navigator.articleListByCategoryCellTapped(articleID: articleID)
                case .backButton:
                    self.navigator.backButtonTapped()
                case .expire:
                    self.navigator.checkTokenIsExpired()
                }
            }
            .store(in: &cancelBag)
        
        let articleDatas = input.viewWillAppear
            .flatMap { _ -> AnyPublisher<[ArticleDataByWeek], Never> in
                return Future<[ArticleDataByWeek], NetworkError> { promise in
                    Task {
                        do {
                            let articlesData = try await self.getArticleListByCategory(categoryString: self.categoryString)
                            self.articleListData = articlesData
                            promise(.success(articlesData))
                        } catch {
                            guard let error = error as? NetworkError else { return }
                            promise(.failure(error))
                        }
                    }
                }
                .catch { error in
                    self.handleError(error: error)
                    let empty: [ArticleDataByWeek] = []
                    return Just(empty)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        
        let bookmark = input.bookmarkTapped
            .flatMap { (isSelected: Bool, indexPath: IndexPath) -> AnyPublisher<String, Never> in
                return Future<String, NetworkError> { promise in
                    Task {
                        do {
                            guard let articleId = self.articleListData?[indexPath.row].articleId
                            else { return }
                            try await self.bookmarkArticle(articleId: articleId, isSelected: isSelected)
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }.catch { error in
                    self.handleError(error: error)
                    return Just(error.description)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        
        
        input.articleCellTapped
            .sink { [weak self] indexPath in
                guard let self,
                      let articleId = self.articleListData?[indexPath.row].articleId
                else { return }
                
                self.navigationSubject.send(.article(articleId: articleId))
            }
            .store(in: &cancelBag)
        
        input.backButtonTapped
            .sink { _ in
                self.navigationSubject.send(.backButton)
            }
            .store(in: &cancelBag)
        
        return Output(articles: articleDatas, bookmarkCompleted: bookmark)
    }
    
    func setCategoryTitle(title: String) {
        self.categoryString = title
        
    }
    
}

extension ArticleListByCategoryViewModelImpl {
    private func getArticleListByCategory(categoryString: String?) async throws -> [ArticleDataByWeek] {
        guard let categoryString else { return [] }
        return try await manager.getArticleListByCategory(categoryString: categoryString).articleData
    }
    
    private func handleError(error: NetworkError) {
        switch error {
        case .unAuthorizedError:
            self.navigationSubject.send(.expire)
        default:
            self.errorSubject.send(error)
        }
    }
    
    private func bookmarkArticle(articleId: Int, isSelected: Bool) async throws {
        try await self.manager.postBookmark(model: BookmarkRequest(articleId: articleId,
                                                                      bookmarkRequestStatus: isSelected))
    }
}
