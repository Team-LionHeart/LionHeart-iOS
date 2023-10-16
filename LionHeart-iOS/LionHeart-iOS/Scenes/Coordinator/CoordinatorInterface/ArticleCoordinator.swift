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
    
    var factory: ArticleFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: ArticleFactory, articleId: Int) {
        self.navigationController = navigationController
        self.factory = factory
        self.articleId = articleId
    }
    
    func start() {
        showArticleDetailViewController()
    }
    
    func showArticleDetailViewController() {
        let articleDetailViewController = factory.makeArticleDetailViewController()
        articleDetailViewController.setArticleId(id: articleId)
        articleDetailViewController.coordinator = self
        articleDetailViewController.isModalInPresentation = true
        articleDetailViewController.modalPresentationStyle = .fullScreen
        navigationController.present(articleDetailViewController, animated: true)
    }
}

extension ArticleCoordinator: ArticleDetailModalNavigation {
    func checkTokenIsExpired() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    
    func closeButtonTapped() {
        self.navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
