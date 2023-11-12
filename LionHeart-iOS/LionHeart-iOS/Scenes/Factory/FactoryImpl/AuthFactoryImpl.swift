//
//  AuthFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct AuthFactoryImpl: AuthFactory {
    func makeLoginViewModel(coordinator: AuthCoordinator) -> LoginViewModelPresentable {
        let adaptor = self.makeAuthAdaptor(coordinator: coordinator)
        
        let apiService = APIService()
        let serviceImpl = AuthServiceImpl(apiService: apiService)
        let manager = LoginMangerImpl(authService: serviceImpl)
        return LoginViewModelImpl(navigator: adaptor, manager: manager)
    }
    
    func makeAuthAdaptor(coordinator: AuthCoordinator) -> EntireAuthNaviation {
        return AuthAdaptor(coordinator: coordinator)
    }
    
    func makeLoginViewController(coordinator: AuthCoordinator) -> LoginViewController {
        let viewModel = self.makeLoginViewModel(coordinator: coordinator)
        return LoginViewController(viewModel: viewModel)
    }
    
    func makeCompleteOnbardingViewController(coordinator: AuthCoordinator) -> CompleteOnbardingViewControllerable {
        let completeViewController = CompleteOnbardingViewController(navigator: self.makeAuthAdaptor(coordinator: coordinator))
        return completeViewController
    }
    
    func makeOnboardingViewController(coordinator: AuthCoordinator) -> OnboardingViewControllerable {
        let onboardingViewController = OnboardingViewController(manager: OnboardingManagerImpl(authService: AuthServiceImpl(apiService: APIService())), navigator: self.makeAuthAdaptor(coordinator: coordinator))
        return onboardingViewController
    }
    

}
