//
//  ArticleCategortFactory.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

protocol ArticleCategortFactory {
    func makeArticleCategoryViewController(navigator: ArticleCategoryNavigation) -> ArticleCategoryViewControllerable
    func makeArticleListByCategoryViewController(navigator: ArticleListByCategoryNavigation) -> ArticleListByCategoryViewControllerable
}
