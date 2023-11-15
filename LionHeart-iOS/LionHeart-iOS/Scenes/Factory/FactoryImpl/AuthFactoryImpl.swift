//
//  AuthFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct AuthFactoryImpl: AuthFactory {

    
    func makeOnboardingViewModel(coordinator: AuthCoordinator) -> any OnboardingViewModel & OnboardingViewModelPresentable {
        let adaptor = self.makeAuthAdaptor(coordinator: coordinator)
        let apiService = APIService()
        let serviceImpl = AuthServiceImpl(apiService: apiService)
        let managerImpl = OnboardingManagerImpl(authService: serviceImpl)
        return OnboardingViewModelImpl(navigator: adaptor, manager: managerImpl)
    }


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
    
    func makeLoginViewController(coordinator: AuthCoordinator) -> LoginViewControllerable {
        let viewModel = self.makeLoginViewModel(coordinator: coordinator)
        return LoginViewController(viewModel: viewModel)
    }
    
    func makeCompleteOnbardingViewController(coordinator: AuthCoordinator) -> CompleteOnbardingViewControllerable {
        let adaptor = self.makeAuthAdaptor(coordinator: coordinator)
        let completeViewController = CompleteOnbardingViewController(navigator: adaptor)
        return completeViewController
    }

    func makeOnboardingViewController(token: String?, coordinator: AuthCoordinator) -> OnboardingViewControllerable {
        let viewModel = self.makeOnboardingViewModel(coordinator: coordinator)
        viewModel.setKakaoAccessToken(token)
        return OnboardingViewController(viewModel: viewModel)
    }
    
}
