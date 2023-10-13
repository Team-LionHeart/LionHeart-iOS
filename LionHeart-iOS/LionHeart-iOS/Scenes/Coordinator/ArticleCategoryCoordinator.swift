//
//  ArticleCategoryCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class ArticleCategoryCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showArticleCategoryViewController()
    }
    
    func showArticleCategoryViewController() {
        let articleCategoryViewController = ArticleCategoryViewController()
        articleCategoryViewController.coordinator = self
        self.navigationController.pushViewController(articleCategoryViewController, animated: true)
    }
}

extension ArticleCategoryCoordinator: ArticleCategoryNavigation, ArticleListByCategoryNavigation {
    func articleListByCategoryCellTapped(articleID: Int) {
        let articleCoordinator = ArticleCoordinator(
            navigationController: navigationController,
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
        let articleListbyCategoryViewController = ArticleListByCategoryViewController(manager: ArticleListByCategoryMangerImpl(articleService: ArticleServiceImpl(apiService: APIService()), bookmarkService: BookmarkServiceImpl(apiService: APIService())))
        articleListbyCategoryViewController.categoryString = categoryName
        articleListbyCategoryViewController.coordinator = self
        self.navigationController.pushViewController(articleListbyCategoryViewController, animated: true)
    }
    
    func checkTokenIsExpired() {
        let splashCoordinator = parentCoordinator as? SplashCoordinator
        splashCoordinator?.start()
    }
    
    func navigationRightButtonTapped() {
        let mypageCoordinator = MypageCoordinator(navigationController: navigationController)
        mypageCoordinator.start()
        children.append(mypageCoordinator)
    }
    
    func navigationLeftButtonTapped() {
        let bookmarkCoordinator = BookmarkCoordinator(navigationController: navigationController)
        bookmarkCoordinator.start()
        children.append(bookmarkCoordinator)
    }
}
