//
//  ArticleCategortFactory.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

protocol ArticleCategortFactory {
    func makeArticleCategoryViewModel(cooridnator: ArticleCategoryNavigation) -> any ArticleCategoryViewModel & ArticleCategoryViewModelPresentable
    func makeArticleCategoryAdaptor(coordinator: ArticleCategoryCoordinator) -> EntireArticleCategoryNavigation
    func makeArticleListByCategoryViewController(coordinator: ArticleCategoryCoordinator) -> ArticleListByCategoryViewControllerable
    func makeArticleCategoryViewController(coordinator: ArticleCategoryNavigation) -> ArticleCategoryViewControllerable
}
