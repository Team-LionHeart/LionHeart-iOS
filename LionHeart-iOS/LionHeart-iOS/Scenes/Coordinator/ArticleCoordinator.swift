//
//  ArticleCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class ArticleCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var articleId: Int
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, articleId: Int) {
        self.navigationController = navigationController
        self.articleId = articleId
    }
    
    func start() {
        showArticleDetailViewController()
    }
    
    func showArticleDetailViewController() {
        let articleDetailViewController = ArticleDetailViewController(manager: ArticleDetailManagerImpl(articleService: ArticleServiceImpl(apiService: APIService()), bookmarkService: BookmarkServiceImpl(apiService: APIService())))
        articleDetailViewController.coordinator = self
        articleDetailViewController.setArticleId(id: articleId)
        articleDetailViewController.isModalInPresentation = true
        articleDetailViewController.modalPresentationStyle = .fullScreen
        navigationController.present(articleDetailViewController, animated: true)
    }
}

extension ArticleCoordinator: ArticleDetailModalNavigation {
    
    func checkTokenIsExpired() {
        let splashCoordinator = parentCoordinator as? SplashCoordinator
        splashCoordinator?.start()
    }
    
    func closeButtonTapped() {
        self.navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
