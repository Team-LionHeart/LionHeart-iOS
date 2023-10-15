//
//  ArticleCategoryCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class ArticleCategoryCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    private let factory: ArticleCategortFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: ArticleCategortFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showArticleCategoryViewController()
    }
    
    func showArticleCategoryViewController() {
        let articleCategoryViewController = factory.makeArticleCategoryViewController()
        articleCategoryViewController.coordinator = self
        self.navigationController.pushViewController(articleCategoryViewController, animated: true)
    }
}

extension ArticleCategoryCoordinator: ArticleCategoryNavigation, ArticleListByCategoryNavigation {
    func articleListByCategoryCellTapped(articleID: Int) {
        let articleCoordinator = ArticleCoordinator(
            navigationController: navigationController, 
            factory: ArticleFactoryImpl(),
            articleId: articleID
        )
        articleCoordinator.parentCoordinator = self
        children.append(articleCoordinator)
        articleCoordinator.start()
    }
    
    func backButtonTapped() {
        self.navigationController.popViewController(animated: true)
    }
    
    func articleListCellTapped(categoryName: String) {
        let articleListbyCategoryViewController = factory.makeArticleListByCategoryViewController()
        articleListbyCategoryViewController.categoryString = categoryName
        articleListbyCategoryViewController.coordinator = self
        self.navigationController.pushViewController(articleListbyCategoryViewController, animated: true)
    }
    
    func navigationRightButtonTapped() {
        let mypageCoordinator = MypageCoordinator(
            navigationController: navigationController,
            factory: MyPageFactoryImpl()
        )
        mypageCoordinator.start()
        children.append(mypageCoordinator)
    }
    
    func navigationLeftButtonTapped() {
        let bookmarkFactory = BookmarkFactoryImpl()
        let bookmarkCoordinator = BookmarkCoordinator(navigationController: navigationController, factory: bookmarkFactory)
        bookmarkCoordinator.start()
        children.append(bookmarkCoordinator)
    }
}
