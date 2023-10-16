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
    
    func start() {
        showTodayViewController()
    }
    
    func showTodayViewController() {
        let todayAdaptor = TodayAdaptor(coordinator: self)
        let todayVC = factory.makeTodayViewController(adaptor: todayAdaptor)
        self.navigationController.pushViewController(todayVC, animated: true)
    }
    
    func showArticleDetaileViewController(articleID: Int) {
        let articleCoordinator = ArticleCoordinator(
            navigationController: navigationController,
            factory: ArticleFactoryImpl(),
            articleId: articleID
        )
        articleCoordinator.parentCoordinator = self
        children.append(articleCoordinator)
        articleCoordinator.start()
    }
    
    func showMypageViewController() {
        let mypageCoordinator = MypageCoordinator(navigationController: navigationController,
                                                  factory: MyPageFactoryImpl())
        mypageCoordinator.start()
        children.append(mypageCoordinator)
    }
    
    func showBookmarkViewController() {
        let bookmarkFactory = BookmarkFactoryImpl()
        let bookmarkCoordinator = BookmarkCoordinator(navigationController: navigationController, factory: bookmarkFactory)
        bookmarkCoordinator.start()
        children.append(bookmarkCoordinator)
    }
    
    func exitApplication() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}
