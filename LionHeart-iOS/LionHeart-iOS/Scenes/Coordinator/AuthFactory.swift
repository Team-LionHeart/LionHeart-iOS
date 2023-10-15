//
//  AuthFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/15.
//

import Foundation

protocol AuthFactory {
    func makeLoginViewController() -> LoginViewControllerable
    func makeCompleteOnbardingViewController() -> CompleteOnbardingViewControllerable
    func makeOnboardingViewController() -> OnboardingViewControllerable
}

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
