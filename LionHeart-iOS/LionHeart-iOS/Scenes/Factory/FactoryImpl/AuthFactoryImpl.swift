//
//  AuthFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct AuthFactoryImpl: AuthFactory {
    
    func makeLoginViewController(navigator: LoginNavigation) -> LoginViewControllerable {
        let loginViewController = LoginViewController(manager: LoginMangerImpl(authService: AuthServiceImpl(apiService: APIService())), navigator: navigator)
        return loginViewController
    }
    
    func makeCompleteOnbardingViewController(navigator: CompleteOnbardingNavigation) -> CompleteOnbardingViewControllerable {
        let completeViewController = CompleteOnbardingViewController(navigator: navigator)
        return completeViewController
    }
    
    func makeOnboardingViewController(navigator: OnboardingNavigation) -> OnboardingViewControllerable {
        let onboardingViewController = OnboardingViewController(manager: OnboardingManagerImpl(authService: AuthServiceImpl(apiService: APIService())), navigator: navigator)
        return onboardingViewController
    }
    

}
