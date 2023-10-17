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
        let adaptor = BookmarkAdaptor(coordinator: self)
        let bookmarkViewController = factory.makeBookmarkViewController(adaptor: adaptor)
        self.navigationController.pushViewController(bookmarkViewController, animated: true)
    }
    
    func showArticleDetailViewController(articleId: Int) {
        let articleCoordinator = ArticleCoordinator(
            navigationController: navigationController,
            factory: ArticleFactoryImpl(),
            articleId: articleId)
        articleCoordinator.start()
        children.append(articleCoordinator)
    }
    
    func popDismiss() {
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

