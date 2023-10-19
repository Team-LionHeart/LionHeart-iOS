//
//  AppCoordinatorImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class AppCoordinatorImpl: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func startSplashCoordinator() {
        let splashCoordinator = SplashCoordinatorImpl(navigationController: navigationController, factory: SplashFactoryImpl())
        children.removeAll()
        splashCoordinator.parentCoordinator = self
        children.append(splashCoordinator)
        splashCoordinator.showSplashViewController()
    }
}
