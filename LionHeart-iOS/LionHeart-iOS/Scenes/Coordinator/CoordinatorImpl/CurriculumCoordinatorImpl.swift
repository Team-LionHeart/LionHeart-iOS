//
//  CurriculumCoordinatorImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/17/23.
//

import UIKit


final class CurriculumCoordinatorImpl: CurriculumCoordinator {
    
    weak var parentCoordinator: Coordinator?
    
    let factory: CurriculumFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: CurriculumFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showCurriculumViewController()
    }
    
    /// CurriculumListByWeekVC -> ArticleDetailVC
    func showArticleDetailViewController(articleId: Int) {
        let articleCoordinator = ArticleCoordinatorImpl(
            navigationController: navigationController,
            factory: ArticleFactoryImpl(),
            articleId: articleId
        )
        articleCoordinator.parentCoordinator = self
        children.append(articleCoordinator)
        articleCoordinator.start()
    }
    
    func showCurriculumListViewController(itemIndex: Int) {
        let curriculumListViewController = factory.makeCurriculumListViewController(coordinator: self) // After
        curriculumListViewController.setWeekIndexPath(week: itemIndex)
        navigationController.pushViewController(curriculumListViewController, animated: true)
    }

    func showMypageViewController() {
        let mypageCoordinator = MyPageCoordinatorImpl(
            navigationController: navigationController,
            factory: MyPageFactoryImpl()
        )
        mypageCoordinator.start()
        children.append(mypageCoordinator)
    }
    
    func showBookmarkViewController() {
        let bookmarkFactory = BookmarkFactoryImpl()
        let bookmarkCoordinator = BookmarkCoordinatorImpl(navigationController: navigationController, factory: bookmarkFactory)
        bookmarkCoordinator.start()
        children.append(bookmarkCoordinator)
    }
    
    func pop() {
        self.navigationController.popViewController(animated: true)
    }
    
    func exitApplication() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    func showCurriculumViewController() {
        let curriculumVC = factory.makeCurriculumViewController(coordinator: self)
        navigationController.pushViewController(curriculumVC, animated: true)
    }
}
