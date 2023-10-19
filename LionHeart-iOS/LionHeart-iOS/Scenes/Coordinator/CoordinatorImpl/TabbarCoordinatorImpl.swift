//
//  TabbarCoordinatorImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class TabbarCoordinatorImpl: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showTabbarController()
    }
    
    func showTabbarController() {
        let tabbarController = TabBarViewController()
        
        let todayNavigationController = UINavigationController()
        let todayCoordinator = TodayCoordinatorImpl(navigationController: todayNavigationController, factory: TodayFactoryImpl())
        todayCoordinator.parentCoordinator = parentCoordinator
        todayNavigationController.tabBarItem = UITabBarItem(title: "투데이", image: .assetImage(.home), tag: 0)
        
        let articleCategoryNavigationController = UINavigationController()
        let articleCategoryCoordinator = ArticleCategoryCoordinatorImpl(navigationController: articleCategoryNavigationController, factory: ArticleCategortFactoryImpl())
        articleCategoryCoordinator.parentCoordinator = parentCoordinator
        articleCategoryNavigationController.tabBarItem = UITabBarItem(title: "탐색", image: .assetImage(.search), tag: 1)
        
        let curriculumNavigationController = UINavigationController()
        let curriculumCoordinator = CurriculumCoordinatorImpl(
            navigationController: curriculumNavigationController,
            factory: CurriculumFactoryImpl()
        )
        curriculumNavigationController.tabBarItem = UITabBarItem(title: "커리큘럼", image: .assetImage(.curriculum), tag: 2)
        curriculumCoordinator.parentCoordinator = parentCoordinator
        
        let challengeNavigationController = UINavigationController()
        let challengeCoordinator = ChallengeCoordinatorImpl(navigationController: challengeNavigationController, factory: ChallengeFactoryImpl())
        challengeCoordinator.parentCoordinator = parentCoordinator
        challengeNavigationController.tabBarItem = UITabBarItem(title: "챌린지", image: .assetImage(.challenge), tag: 3)
        
        tabbarController.viewControllers = [todayNavigationController, articleCategoryNavigationController, curriculumNavigationController, challengeNavigationController]
        
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(tabbarController, animated: true)
        navigationController.isNavigationBarHidden = true
        parentCoordinator?.children = [todayCoordinator, articleCategoryCoordinator, curriculumCoordinator, challengeCoordinator]
        
        todayCoordinator.showTodayViewController()
        articleCategoryCoordinator.showArticleCategoryViewController()
        curriculumCoordinator.showCurriculumViewController()
        challengeCoordinator.showChallengeViewController()
    }
}
