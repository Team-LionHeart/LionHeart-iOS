//
//  ArticleCategortFactory.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

protocol ArticleCategortFactory {
    func makeArticleListByCategoryViewModel(cooridnator: ArticleCategoryCoordinator) -> any ArticleListByCategoryViewModel & ArticleListByCategoryViewModelPresentable
    
    func makeArticleCategoryViewModel(cooridnator: ArticleCategoryCoordinator) -> any ArticleCategoryViewModel & ArticleCategoryViewModelPresentable
    
    func makeArticleCategoryAdaptor(coordinator: ArticleCategoryCoordinator) -> EntireArticleCategoryNavigation
    
    func makeArticleListByCategoryViewController(coordinator: ArticleCategoryCoordinator, categoryName: String) -> ArticleListByCategoryViewControllerable
    
    func makeArticleCategoryViewController(coordinator: ArticleCategoryCoordinator) -> ArticleCategoryViewControllerable
}
