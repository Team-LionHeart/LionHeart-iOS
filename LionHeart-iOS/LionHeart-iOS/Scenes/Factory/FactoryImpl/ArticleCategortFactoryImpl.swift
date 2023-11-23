//
//  ArticleCategortFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

struct ArticleCategortFactoryImpl: ArticleCategortFactory {
    func makeArticleCategoryViewModel(cooridnator: ArticleCategoryNavigation) -> any ArticleCategoryViewModel & ArticleCategoryViewModelPresentable {
        return ArticleCategoryViewModelImpl(navigator: cooridnator)
    }
    
    func makeArticleCategoryAdaptor(coordinator: ArticleCategoryCoordinator) -> EntireArticleCategoryNavigation {
        return ArticleCategoryAdaptor(coordinator: coordinator)
    }
    
    func makeArticleListByCategoryViewController(coordinator: ArticleCategoryCoordinator) -> ArticleListByCategoryViewControllerable {
        return ArticleListByCategoryViewController(manager: ArticleListByCategoryMangerImpl(articleService: ArticleServiceImpl(apiService: APIService()), bookmarkService: BookmarkServiceImpl(apiService: APIService())), navigator: self.makeArticleCategoryAdaptor(coordinator: coordinator))
    }
    
    func makeArticleCategoryViewController(coordinator: ArticleCategoryNavigation) -> ArticleCategoryViewControllerable {
        let viewModel = self.makeArticleCategoryViewModel(cooridnator: coordinator)
        return ArticleCategoryViewController(viewModel: viewModel)
    }
}
