//
//  ArticleCategoryCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class ArticleCategoryCoordinatorImpl: ArticleCategoryCoordinator {

    weak var parentCoordinator: Coordinator?
    
    private let factory: ArticleCategortFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: ArticleCategortFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func showArticleCategoryViewController() {
        let articleCategoryViewController = factory.makeArticleCategoryViewController(coordinator: self)
        self.navigationController.pushViewController(articleCategoryViewController, animated: true)
    }
    
    func showArticleDetailViewController(articleID: Int) {
        let articleCoordinator = ArticleCoordinatorImpl(
            navigationController: navigationController,
            factory: ArticleFactoryImpl(),
            articleId: articleID
        )
        articleCoordinator.parentCoordinator = self
        children.append(articleCoordinator)
        articleCoordinator.showArticleDetailViewController()
    }
    
    func showArticleListbyCategoryViewController(categoryName: String) {
        let articleListbyCategoryViewController = factory.makeArticleListByCategoryViewController(coordinator: self, categoryName: categoryName)
        self.navigationController.pushViewController(articleListbyCategoryViewController, animated: true)
    }
    
    func showBookmarkViewController() {
        let bookmarkFactory = BookmarkFactoryImpl()
        let bookmarkCoordinator = BookmarkCoordinatorImpl(navigationController: navigationController, factory: bookmarkFactory)
        bookmarkCoordinator.showBookmarkViewController()
        children.append(bookmarkCoordinator)
    }
    
    func showMypageViewController() {
        let mypageCoordinator = MyPageCoordinatorImpl(
            navigationController: navigationController,
            factory: MyPageFactoryImpl()
        )
        mypageCoordinator.showMyPageViewController()
        children.append(mypageCoordinator)
    }
    
    func pop() {
        self.navigationController.popViewController(animated: true)
    }
    
    func exitApplication() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}
