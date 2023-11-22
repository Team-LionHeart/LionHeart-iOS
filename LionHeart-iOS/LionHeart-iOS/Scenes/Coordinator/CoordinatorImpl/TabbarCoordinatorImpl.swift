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
        let articleCategoryNavigationController = UINavigationController()
        let curriculumNavigationController = UINavigationController()
        let challengeNavigationController = UINavigationController()
        
        startTodayArticleFlow(todayNavigationController)
        startArticleCategoryFlow(articleCategoryNavigationController)
        startCurriculumFlow(curriculumNavigationController)
        startChallengeFlow(challengeNavigationController)
        
        tabbarController.viewControllers = [todayNavigationController, articleCategoryNavigationController, curriculumNavigationController, challengeNavigationController]
        
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(tabbarController, animated: true)
        navigationController.isNavigationBarHidden = true
    }
}

private extension TabbarCoordinatorImpl {
    
    func startTodayArticleFlow(_ navi: UINavigationController) {
        let todayCoordinator = TodayCoordinatorImpl(navigationController: navi, factory: TodayFactoryImpl())
        todayCoordinator.parentCoordinator = parentCoordinator
        navi.tabBarItem = .makeTabItem(.today)
        self.parentCoordinator?.children.append(todayCoordinator)
        todayCoordinator.showTodayViewController()
    }
    
    func startArticleCategoryFlow(_ navi: UINavigationController) {
        let articleCategoryCoordinator = ArticleCategoryCoordinatorImpl(navigationController: navi, factory: ArticleCategortFactoryImpl())
        articleCategoryCoordinator.parentCoordinator = parentCoordinator
        navi.tabBarItem = .makeTabItem(.category)
        self.parentCoordinator?.children.append(articleCategoryCoordinator)
        articleCategoryCoordinator.showArticleCategoryViewController()
    }
    
    func startCurriculumFlow(_ navi: UINavigationController) {
        let curriculumCoordinator = CurriculumCoordinatorImpl(navigationController: navi, factory: CurriculumFactoryImpl())
        navi.tabBarItem = .makeTabItem(.curriculum)
        curriculumCoordinator.parentCoordinator = parentCoordinator
        self.parentCoordinator?.children.append(curriculumCoordinator)
        curriculumCoordinator.showCurriculumViewController()
    }

    func startChallengeFlow(_ navi: UINavigationController) {
        let challengeCoordinator = ChallengeCoordinatorImpl(navigationController: navi, factory: ChallengeFactoryImpl())
        challengeCoordinator.parentCoordinator = parentCoordinator
        navi.tabBarItem = .makeTabItem(.challenge)
        self.parentCoordinator?.children.append(challengeCoordinator)
        challengeCoordinator.showChallengeViewController()
    }
}
