//
//  SplashCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class SplashCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    private let factory: SplashFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: SplashFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showSplashViewController()
    }
    
    func showSplashViewController() {
        let splashViewController = factory.makeSplashViewController()
        splashViewController.coordinator = self
        self.navigationController.pushViewController(splashViewController, animated: false)
    }
    
    func showTabbar() {
        let tabbarCoordinator = TabbarCoordinator(navigationController: navigationController)
        children.removeAll()
        tabbarCoordinator.parentCoordinator = self
        tabbarCoordinator.start()
    }
    
    func showLogin() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController, factory: AuthFactoryImpl())
        children.removeAll()
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        authCoordinator.start()
    }
}

extension SplashCoordinator: SplashNavigation {
    func checkToken(state: TokenState) {
        switch state {
        case .valid:
            showTabbar()
        case .expired:
            showLogin()
        }
    }
}
