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
    
    func showTabbarController() {
        let tabbarController = TabBarViewController()
        let todayNavigationController = UINavigationController()
        let articleCategoryNavigationController = UINavigationController()
        let curriculumNavigationController = UINavigationController()
        let challengeNavigationController = UINavigationController()
        
        startTodayArticleFlow(todayNavigationController, from: parentCoordinator)
        startArticleCategoryFlow(articleCategoryNavigationController, from: parentCoordinator)
        startCurriculumFlow(curriculumNavigationController, from: parentCoordinator)
        startChallengeFlow(challengeNavigationController, from: parentCoordinator)
        
        tabbarController.viewControllers = [todayNavigationController, articleCategoryNavigationController, curriculumNavigationController, challengeNavigationController]
        
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(tabbarController, animated: true)
        navigationController.isNavigationBarHidden = true
    }
}

private extension TabbarCoordinatorImpl {
    
    func startTodayArticleFlow(_ navi: UINavigationController, from parent: Coordinator?) {
        let todayCoordinator = TodayCoordinatorImpl(navigationController: navi, factory: TodayFactoryImpl())
        todayCoordinator.parentCoordinator = parent
        navi.tabBarItem = .makeTabItem(.today)
        parent?.children.append(todayCoordinator)
        todayCoordinator.showTodayViewController()
    }
    
    func startArticleCategoryFlow(_ navi: UINavigationController, from parent: Coordinator?) {
        let articleCategoryCoordinator = ArticleCategoryCoordinatorImpl(navigationController: navi, factory: ArticleCategortFactoryImpl())
        articleCategoryCoordinator.parentCoordinator = parent
        navi.tabBarItem = .makeTabItem(.category)
        parent?.children.append(articleCategoryCoordinator)
        articleCategoryCoordinator.showArticleCategoryViewController()
    }
    
    func startCurriculumFlow(_ navi: UINavigationController, from parent: Coordinator?) {
        let curriculumCoordinator = CurriculumCoordinatorImpl(navigationController: navi, factory: CurriculumFactoryImpl())
        navi.tabBarItem = .makeTabItem(.curriculum)
        curriculumCoordinator.parentCoordinator = parent
        parent?.children.append(curriculumCoordinator)
        curriculumCoordinator.showCurriculumViewController()
    }

    func startChallengeFlow(_ navi: UINavigationController, from parent: Coordinator?) {
        let challengeCoordinator = ChallengeCoordinatorImpl(navigationController: navi, factory: ChallengeFactoryImpl())
        challengeCoordinator.parentCoordinator = parent
        navi.tabBarItem = .makeTabItem(.challenge)
        parent?.children.append(challengeCoordinator)
        challengeCoordinator.showChallengeViewController()
    }
}
