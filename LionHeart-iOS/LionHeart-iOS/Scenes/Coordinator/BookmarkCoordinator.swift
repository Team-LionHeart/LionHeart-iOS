//
//  BookmarkCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class BookmarkCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showBookmarkViewController()
    }
    
    func showBookmarkViewController() {
        let bookmarkViewController = BookmarkViewController(manager: BookmarkMangerImpl(bookmarkService: BookmarkServiceImpl(apiService: APIService())))
        bookmarkViewController.coordinator = self
        self.navigationController.pushViewController(bookmarkViewController, animated: true)
    }
}

extension BookmarkCoordinator: BookmarkNavigation {
    func bookmarkCellTapped(articleID: Int) {
        let articleCoordinator = ArticleCoordinator(navigationController: navigationController, articleId: articleID)
        articleCoordinator.start()
        children.append(articleCoordinator)
    }
    
    func backButtonTapped() {
        self.navigationController.popViewController(animated: true)
        self.parentCoordinator?.childDidFinish(self)
    }
}
