//
//  TabbbarCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class TabbarCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
        showTabbar()
    }
    
    func showTabbar() {
        let tabbarController = TabBarViewController()
        
//        let todayViewController = UINavigationController(rootViewController: TodayViewController(manager: TodayManagerImpl(articleService: ArticleServiceImpl(apiService: APIService()))))
        
        let todayNavigationController = UINavigationController()
        let todayCoordinator = TodayCoordinator(navigationController: todayNavigationController)
        todayCoordinator.parentCoordinator = parentCoordinator
        todayNavigationController.tabBarItem = UITabBarItem(title: "투데이", image: .assetImage(.home), tag: 0)
        
        
        let articleCategoryNavigationController = UINavigationController()
        let articleCategoryCoordinator = ArticleCategoryCoordinator(navigationController: articleCategoryNavigationController)
        articleCategoryCoordinator.parentCoordinator = parentCoordinator
        articleCategoryNavigationController.tabBarItem = UITabBarItem(title: "탐색", image: .assetImage(.search), tag: 1)
        
        let curriculumNavigationController = UINavigationController()
        let curriculumCoordinator = CurriculumCoordinator(navigationController: curriculumNavigationController)
        
//        let curriculumViewController = UINavigationController(rootViewController: CurriculumViewController(manager: CurriculumManagerImpl(curriculumService: CurriculumServiceImpl(apiService: APIService()))))
        curriculumNavigationController.tabBarItem = UITabBarItem(title: "커리큘럼", image: .assetImage(.curriculum), tag: 2)
        curriculumCoordinator.parentCoordinator = parentCoordinator
        
        let challengeNavigationController = UINavigationController()
        let challengeCoordinator = ChallengeCoordinator(navigationController: challengeNavigationController)
        challengeCoordinator.parentCoordinator = parentCoordinator
        
//        let challengeViewController = UINavigationController(rootViewController: ChallengeViewController(manager: ChallengeManagerImpl(challengeService: ChallengeServiceImpl(apiService: APIService()))))
        challengeNavigationController.tabBarItem = UITabBarItem(title: "챌린지", image: .assetImage(.challenge), tag: 3)
        
        tabbarController.viewControllers = [todayNavigationController, articleCategoryNavigationController, curriculumNavigationController, challengeNavigationController]
        
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(tabbarController, animated: true)
        navigationController.isNavigationBarHidden = true
        parentCoordinator?.children = [todayCoordinator, articleCategoryCoordinator, curriculumCoordinator, challengeCoordinator]
        
        todayCoordinator.start()
        articleCategoryCoordinator.start()
        curriculumCoordinator.start()
        challengeCoordinator.start()
    }
    
    
    
}
