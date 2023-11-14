//
//  AuthFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct AuthFactoryImpl: AuthFactory {
    
    func makeLoginViewModel(coordinator: AuthCoordinator) -> any LoginViewModel & LoginViewModelPresentable {
        let adaptor = self.makeAuthAdaptor(coordinator: coordinator)
        
        let apiService = APIService()
        let serviceImpl = AuthServiceImpl(apiService: apiService)
        let managerImpl = LoginMangerImpl(authService: serviceImpl)
        return LoginViewModelImpl(navigator: adaptor, manager: managerImpl)
    }
    
    func makeAuthAdaptor(coordinator: AuthCoordinator) -> EntireAuthNaviation {
        return AuthAdaptor(coordinator: coordinator)
    }
    
    func makeLoginViewController(coordinator: AuthCoordinator) -> LoginViewController {
        let viewModel = self.makeLoginViewModel(coordinator: coordinator)
        return LoginViewController(viewModel: viewModel)
    }
    
    func makeCompleteOnbardingViewController(coordinator: AuthCoordinator) -> CompleteOnbardingViewControllerable {
        let adaptor = self.makeAuthAdaptor(coordinator: coordinator)
        let completeViewController = CompleteOnbardingViewController(navigator: adaptor)
        return completeViewController
    }
    
    func makeOnboardingViewController(coordinator: AuthCoordinator) -> OnboardingViewControllerable {
        let onboardingViewController = OnboardingViewController(manager: OnboardingManagerImpl(authService: AuthServiceImpl(apiService: APIService())), navigator: self.makeAuthAdaptor(coordinator: coordinator))
        return onboardingViewController
    }
    
    
}
