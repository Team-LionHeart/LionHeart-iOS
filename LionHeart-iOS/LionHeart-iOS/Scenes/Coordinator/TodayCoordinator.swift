//
//  TodayCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class TodayCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showTodayViewController()
    }
    
    func showTodayViewController() {
        let todayViewController = TodayViewController(manager: TodayManagerImpl(articleService: ArticleServiceImpl(apiService: APIService())))
        todayViewController.coordinator = self
        self.navigationController.pushViewController(todayViewController, animated: true)
    }
}
extension TodayCoordinator: TodayNavigation {
    func todayArticleTapped(articleID: Int) {
        let articleCoordinator = ArticleCoordinator(
            navigationController: navigationController, 
            factory: ArticleFactoryImpl(),
            articleId: articleID
        )
        articleCoordinator.parentCoordinator = self
        children.append(articleCoordinator)
        articleCoordinator.start()
    }
    
    func navigationRightButtonTapped() {
        let mypageCoordinator = MypageCoordinator(navigationController: navigationController,
                                                  factory: MyPageFactoryImpl())
        mypageCoordinator.start()
        children.append(mypageCoordinator)
    }
    
    func navigationLeftButtonTapped() {
        let bookmarkCoordinator = BookmarkCoordinator(navigationController: navigationController)
        bookmarkCoordinator.start()
        children.append(bookmarkCoordinator)
    }
}
