//
//  BookmarkCoordinatorImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/17/23.
//

import UIKit

final class BookmarkCoordinatorImpl: BookmarkCoordinator {
    
    weak var parentCoordinator: Coordinator?
    private let factory: BookmarkFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: BookmarkFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showBookmarkViewController()
    }
    
    func showBookmarkViewController() {
        let bookmarkViewController = factory.makeBookmarkViewController(coordinator: self)
        self.navigationController.pushViewController(bookmarkViewController, animated: true)
    }
    
    func showArticleDetailViewController(articleId: Int) {
        let articleCoordinator = ArticleCoordinatorImpl(
            navigationController: navigationController,
            factory: ArticleFactoryImpl(),
            articleId: articleId)
        articleCoordinator.showArticleDetailViewController()
        children.append(articleCoordinator)
    }
    
    func pop() {
        self.navigationController.popViewController(animated: true)
        self.parentCoordinator?.childDidFinish(self)
    }
    
    func exitApplication() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}

