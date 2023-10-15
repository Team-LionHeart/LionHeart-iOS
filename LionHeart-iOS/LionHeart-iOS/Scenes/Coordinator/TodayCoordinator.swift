//
//  TodayCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class TodayCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    private let factory: TodayFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: TodayFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showTodayViewController()
    }
    
    func showTodayViewController() {
        let todayViewController = factory.makeTodayFactory()
        todayViewController.coordinator = self
        self.navigationController.pushViewController(todayViewController, animated: true)
    }
}
extension TodayCoordinator: TodayNavigation {
    func todayArticleTapped(articleID: Int) {
        let articleCoordinator = ArticleCoordinator(
            navigationController: navigationController,
            articleId: articleID
        )
        articleCoordinator.parentCoordinator = self
        children.append(articleCoordinator)
        articleCoordinator.start()
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
