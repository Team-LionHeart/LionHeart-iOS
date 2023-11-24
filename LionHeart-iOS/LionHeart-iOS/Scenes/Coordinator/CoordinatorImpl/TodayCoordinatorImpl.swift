//
//  TodayCoordinatorImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/16.
//

import UIKit

final class TodayCoordinatorImpl: TodayCoordinator {
    weak var parentCoordinator: Coordinator?
    private let factory: TodayFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: TodayFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func showTodayViewController() {
        let todayViweController = factory.makeTodayViewController(coordinator: self)
        self.navigationController.pushViewController(todayViweController, animated: true)
    }
    
    func showArticleDetaileViewController(articleID: Int) {
        let articleCoordinator = ArticleCoordinatorImpl(
            navigationController: navigationController,
            factory: ArticleFactoryImpl(),
            articleId: articleID
        )
        articleCoordinator.parentCoordinator = self
        children.append(articleCoordinator)
        articleCoordinator.showArticleDetailViewController()
    }
    
    func showMypageViewController() {
        let mypageCoordinator = MyPageCoordinatorImpl(navigationController: navigationController,
                                                  factory: MyPageFactoryImpl())
        mypageCoordinator.showMyPageViewController()
        children.append(mypageCoordinator)
    }
    
    func showBookmarkViewController() {
        let bookmarkFactory = BookmarkFactoryImpl()
        let bookmarkCoordinator = BookmarkCoordinatorImpl(navigationController: navigationController, factory: bookmarkFactory)
        bookmarkCoordinator.showBookmarkViewController()
        children.append(bookmarkCoordinator)
    }
    
    func exitApplication() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}
