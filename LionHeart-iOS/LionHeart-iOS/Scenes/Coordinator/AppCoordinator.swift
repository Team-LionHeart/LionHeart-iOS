//
//  AppCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        startSplashCoordinator()
    }
    
    func startSplashCoordinator() {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        children.removeAll()
        splashCoordinator.parentCoordinator = self
        children.append(splashCoordinator)
        splashCoordinator.start()
    }
}
