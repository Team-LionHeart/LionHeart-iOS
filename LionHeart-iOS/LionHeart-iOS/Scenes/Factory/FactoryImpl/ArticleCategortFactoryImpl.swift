//
//  ArticleCategortFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

struct ArticleCategortFactoryImpl: ArticleCategortFactory {
    func makeArticleListByCategoryViewController(navigator: ArticleListByCategoryNavigation) -> ArticleListByCategoryViewControllerable {
        return ArticleListByCategoryViewController(manager: ArticleListByCategoryMangerImpl(articleService: ArticleServiceImpl(apiService: APIService()), bookmarkService: BookmarkServiceImpl(apiService: APIService())), navigator: navigator)
    }
    
    func makeArticleCategoryViewController(navigator: ArticleCategoryNavigation) -> ArticleCategoryViewControllerable {
        return ArticleCategoryViewController(navigator: navigator)
    }

}
