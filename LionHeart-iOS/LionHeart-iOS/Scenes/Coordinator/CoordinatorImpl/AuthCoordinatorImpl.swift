//
//  AuthCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class AuthCoordinatorImpl: AuthCoordinator {
    weak var parentCoordinator: Coordinator?
    private let factory: AuthFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: AuthFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showLoginViewController()
    }
    
    func showLoginViewController() {
        let loginViewController = factory.makeLoginViewController(coordinator: self)
        self.navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func showTabbarController() {
        let splashCoorinator = parentCoordinator as? SplashCoordinatorImpl
        splashCoorinator?.showTabbarViewContoller()
    }
    
    func showOnboardingCompleteViewController(data: UserOnboardingModel) {
        let completeViewController = factory.makeCompleteOnbardingViewController(coordinator: self)
        completeViewController.userData = data
        self.navigationController.pushViewController(completeViewController, animated: true)
    }
    
    func showTabbarOrOnboardingViewController(userState: UserState, kakaoToken: String?) {
        let splashCoorinator = parentCoordinator as? SplashCoordinatorImpl
        switch userState {
        case .verified:
            splashCoorinator?.showTabbarViewContoller()
        case .nonVerified:
            let onboardingViewController = factory.makeOnboardingViewController(token: kakaoToken, coordinator: self)
            DispatchQueue.main.async {
                self.navigationController.pushViewController(onboardingViewController, animated: true)
            }
            
        }
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
}
