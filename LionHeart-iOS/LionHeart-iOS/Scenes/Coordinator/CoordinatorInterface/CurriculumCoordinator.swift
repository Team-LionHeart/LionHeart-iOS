//
//  CurriculumCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class CurriculumCoordinator: Coordinator {
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
    
    func showCurriculumViewController() {
        let curriculumViewController = CurriculumViewController(manager: CurriculumManagerImpl(curriculumService: CurriculumServiceImpl(apiService: APIService())))
        curriculumViewController.coordinator = self
        navigationController.pushViewController(curriculumViewController, animated: true)
    }
}

extension CurriculumCoordinator: CurriculumNavigation, CurriculumListByWeekNavigation {
    func checkTokenIsExpired() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    func curriculumArticleListCellTapped(articleId: Int) {
        let articleCoordinator = ArticleCoordinator(
            navigationController: navigationController, 
            factory: ArticleFactoryImpl(),
            articleId: articleId
        )
        articleCoordinator.parentCoordinator = self
        children.append(articleCoordinator)
        articleCoordinator.start()
    }
    
    func backButtonTapped() {
        self.navigationController.popViewController(animated: true)
    }
    
    func articleListCellTapped(itemIndex: Int) {
        let curriculumViewController = factory.makeCurriculumListViewController()
        curriculumViewController.coordinator = self
        curriculumViewController.setWeekIndexPath(week: itemIndex)
        navigationController.pushViewController(curriculumViewController, animated: true)
    }
    
    func navigationRightButtonTapped() {
        let mypageCoordinator = MyPageCoordinatorImpl(
            navigationController: navigationController,
            factory: MyPageFactoryImpl()
        )
        mypageCoordinator.start()
        children.append(mypageCoordinator)
    }
    
    func navigationLeftButtonTapped() {
        let bookmarkFactory = BookmarkFactoryImpl()
        let bookmarkCoordinator = BookmarkCoordinator(navigationController: navigationController, factory: bookmarkFactory)
        bookmarkCoordinator.start()
        children.append(bookmarkCoordinator)
    }
}
