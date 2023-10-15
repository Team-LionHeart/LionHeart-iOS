//
//  AuthFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct AuthFactoryImpl: AuthFactory {
    func makeLoginViewController() -> LoginViewControllerable {
        let loginViewController = LoginViewController(manager: LoginMangerImpl(authService: AuthServiceImpl(apiService: APIService())))
        return loginViewController
    }
    
    func makeCompleteOnbardingViewController() -> CompleteOnbardingViewControllerable {
        let completeViewController = CompleteOnbardingViewController()
        return completeViewController
    }
    
    func makeOnboardingViewController() -> OnboardingViewControllerable {
        let onboardingViewController = OnboardingViewController(manager: OnboardingManagerImpl(authService: AuthServiceImpl(apiService: APIService())))
        return onboardingViewController
    }
}
