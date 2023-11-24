//
//  ArticleCategortFactory.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

protocol ArticleCategortFactory {
    func makeArticleCategoryAdaptor(coordinator: ArticleCategoryCoordinator) -> EntireArticleCategoryNavigation
    func makeArticleListByCategoryViewModel(cooridnator: ArticleCategoryCoordinator) -> any ArticleListByCategoryViewModel & ArticleListByCategoryViewModelPresentable
    func makeArticleCategoryViewModel(cooridnator: ArticleCategoryCoordinator) -> any ArticleCategoryViewModel & ArticleCategoryViewModelPresentable
    func makeArticleListByCategoryViewController(coordinator: ArticleCategoryCoordinator, categoryName: String) -> ArticleListByCategoryViewControllerable
    func makeArticleCategoryViewController(coordinator: ArticleCategoryCoordinator) -> ArticleCategoryViewControllerable
}
