//
//  ArticleFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation

struct ArticleFactoryImpl: ArticleFactory {
    
    func makeArticleViewModel(coordinator: ArticleCoordinator) -> any ArticleDetailViewModel & ArticleDetailViewModelPresentable {
        let adaptor = self.makeAdaptor(coordinator: coordinator)
        let apiService = APIService()
        let bookmarkService = BookmarkServiceImpl(apiService: apiService)
        let articleService = ArticleServiceImpl(apiService: apiService)
        let manager = ArticleDetailManagerImpl(articleService: articleService,
                                                            bookmarkService: bookmarkService)
        return ArticleDetailViewModelImpl(adaptor: adaptor, manager: manager)
    }
    
    func makeAdaptor(coordinator: ArticleCoordinator) -> EntireArticleAdaptor {
        let adaptor = ArticleAdaptor(coordinator: coordinator)
        return adaptor
    }
    
    func makeArticleDetailViewController(coordinator: ArticleCoordinator, articleId: Int) -> ArticleControllerable {
        let viewModel = self.makeArticleViewModel(coordinator: coordinator)
        viewModel.setArticleId(id: articleId)
        let articleDetailViewController = ArticleDetailViewController(viewModel: viewModel)
        return articleDetailViewController
    }
}
