//
//  ArticleCategoryCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/17.
//

import Foundation

protocol ArticleCategoryCoordinator: Coordinator {
    func showArticleCategoryViewController()
    func exitApplication()
    func showArticleDetailViewController(articleID: Int)
    func showArticleListbyCategoryViewController(categoryName: String)
    func showBookmarkViewController()
    func showMypageViewController()
    func pop()
}
