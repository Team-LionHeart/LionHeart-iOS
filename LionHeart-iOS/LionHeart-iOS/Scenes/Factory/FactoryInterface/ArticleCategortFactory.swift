//
//  ArticleCategortFactory.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

protocol ArticleCategortFactory {
    func makeArticleCategoryAdaptor(coordinator: ArticleCategoryCoordinator) -> EntireArticleCategoryNavigation
    func makeArticleListByCategoryViewController(coordinator: ArticleCategoryCoordinator) -> ArticleListByCategoryViewControllerable
    func makeArticleCategoryViewController(navigator: ArticleCategoryNavigation) -> ArticleCategoryViewControllerable
}
