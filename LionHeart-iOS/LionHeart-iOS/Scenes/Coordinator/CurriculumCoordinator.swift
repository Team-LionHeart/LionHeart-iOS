//
//  CurriculumCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class CurriculumCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
    func curriculumArticleListCellTapped(articleId: Int) {
        let articleCoordinator = ArticleCoordinator(
            navigationController: navigationController,
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
        let curriculumViewController = CurriculumListByWeekViewController(manager: CurriculumListManagerImpl(bookmarkService: BookmarkServiceImpl(apiService: APIService()), curriculumService: CurriculumServiceImpl(apiService: APIService())))
        curriculumViewController.coordinator = self
        curriculumViewController.weekToIndexPathItem = itemIndex
        navigationController.pushViewController(curriculumViewController, animated: true)
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
