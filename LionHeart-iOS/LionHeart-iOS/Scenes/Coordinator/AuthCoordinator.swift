//
//  AuthCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class AuthCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLogin()
    }
    
    func showLogin() {
        let loginViewController = LoginViewController(manager: LoginMangerImpl(authService: AuthServiceImpl(apiService: APIService())))
        loginViewController.coordinator = self
        self.navigationController.pushViewController(loginViewController, animated: true)
    }
}

extension AuthCoordinator: LoginNavigation, OnboardingNavigation, CompleteOnbardingNavigation {
    
    func startButtonTapped() {
        let splashCoorinator = parentCoordinator as? SplashCoordinator
        splashCoorinator?.showTabbar()
    }
    
    func onboardingCompleted(data: UserOnboardingModel) {
        let completeViewController = CompleteOnbardingViewController()
        completeViewController.coordinator = self
        completeViewController.userData = data
        self.navigationController.pushViewController(completeViewController, animated: true)
    }
    
    func backButtonTapped() {
        self.navigationController.popViewController(animated: true)
    }
    
    func checkUserIsVerified(userState: UserState, kakaoToken: String?) {
        let splashCoorinator = parentCoordinator as? SplashCoordinator
        switch userState {
        case .verified:
            splashCoorinator?.showTabbar()
        case .nonVerified:
            let onboardingViewController = OnboardingViewController(manager: OnboardingManagerImpl(authService: AuthServiceImpl(apiService: APIService())))
            onboardingViewController.setKakaoAccessToken(kakaoToken)
            onboardingViewController.coordinator = self
            self.navigationController.pushViewController(onboardingViewController, animated: true)
        }
    }
}
