//
//  AuthCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class AuthCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    private let factory: AuthFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: AuthFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showLogin()
    }
    
    func showLogin() {
        let loginViewController = factory.makeLoginViewController()
        loginViewController.coordinator = self
        self.navigationController.pushViewController(loginViewController, animated: true)
    }
}

extension AuthCoordinator: LoginNavigation, OnboardingNavigation, CompleteOnbardingNavigation {
    func checkTokenIsExpired() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    func startButtonTapped() {
        let splashCoorinator = parentCoordinator as? SplashCoordinatorImpl
        splashCoorinator?.showTabbarViewContoller()
    }
    
    func onboardingCompleted(data: UserOnboardingModel) {
        let completeViewController = factory.makeCompleteOnbardingViewController()
        completeViewController.coordinator = self
        completeViewController.userData = data
        self.navigationController.pushViewController(completeViewController, animated: true)
    }
    
    func backButtonTapped() {
        self.navigationController.popViewController(animated: true)
    }
    
    func checkUserIsVerified(userState: UserState, kakaoToken: String?) {
        let splashCoorinator = parentCoordinator as? SplashCoordinatorImpl
        switch userState {
        case .verified:
            splashCoorinator?.showTabbarViewContoller()
        case .nonVerified:
            let onboardingViewController = factory.makeOnboardingViewController()
            onboardingViewController.setKakaoAccessToken(kakaoToken)
            onboardingViewController.coordinator = self
            self.navigationController.pushViewController(onboardingViewController, animated: true)
        }
    }
}
