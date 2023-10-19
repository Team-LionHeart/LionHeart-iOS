//
//  ArticleCoordinatorImpl.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/19.
//

import UIKit

final class ArticleCoordinatorImpl: ArticleCoordinator {
    
    var parentCoordinator: Coordinator?
    private let factory: ArticleFactory
    private let articleId: Int
    
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
        let articleDetailViewController = factory.makeArticleDetailViewController(coordinator: self)
        articleDetailViewController.setArticleId(id: articleId)
        articleDetailViewController.isModalInPresentation = true
        articleDetailViewController.modalPresentationStyle = .fullScreen
        navigationController.present(articleDetailViewController, animated: true)
    }
    
    func exitApplication() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    func dimiss() {
        self.navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
