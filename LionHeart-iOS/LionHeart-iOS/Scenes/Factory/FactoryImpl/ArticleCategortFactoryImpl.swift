//
//  ArticleCategortFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

struct ArticleCategortFactoryImpl: ArticleCategortFactory {
    func makeArticleCategoryAdaptor(coordinator: ArticleCategoryCoordinator) -> EntireArticleCategoryNavigation {
        return ArticleCategoryAdaptor(coordinator: coordinator)
    }
    
    func makeArticleListByCategoryViewController(coordinator: ArticleCategoryCoordinator) -> ArticleListByCategoryViewControllerable {
        return ArticleListByCategoryViewController(manager: ArticleListByCategoryMangerImpl(articleService: ArticleServiceImpl(apiService: APIService()), bookmarkService: BookmarkServiceImpl(apiService: APIService())), navigator: self.makeArticleCategoryAdaptor(coordinator: coordinator))
    }
    
    func makeArticleCategoryViewController(navigator: ArticleCategoryNavigation) -> ArticleCategoryViewControllerable {
        return ArticleCategoryViewController(navigator: navigator)
    }
}
