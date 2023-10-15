//
//  ArticleCategortFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

struct ArticleCategortFactoryImpl: ArticleCategortFactory {
    func makeArticleCategoryViewController() -> ArticleCategoryViewControllerable {
        return ArticleCategoryViewController()
    }
    
    func makeArticleListByCategoryViewController() -> ArticleListByCategoryViewControllerable {
        let articleListbyCategoryViewController = ArticleListByCategoryViewController(manager: ArticleListByCategoryMangerImpl(articleService: ArticleServiceImpl(apiService: APIService()), bookmarkService: BookmarkServiceImpl(apiService: APIService())))
        return articleListbyCategoryViewController
    }
}
