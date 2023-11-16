//
//  AuthFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct AuthFactoryImpl: AuthFactory {
    func makeCompleteOnboardingViewModel(coordinator: AuthCoordinator, data: UserOnboardingModel) -> any CompleteOnboardingViewModel & CompleteOnboardingViewModelPresentable {
        let adaptor = self.makeAuthAdaptor(coordinator: coordinator)
        let viewModel = CompleteOnboardingViewModelImpl(navigator: adaptor)
        viewModel.setUserData(data)
        return viewModel
    }
    
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
    
    func makeCompleteOnboardingViewController(coordinator: AuthCoordinator, data: UserOnboardingModel) -> CompleteOnboardingViewControllerable {
        let viewModel = self.makeCompleteOnboardingViewModel(coordinator: coordinator, data: data)
        return CompleteOnboardingViewController(viewModel: viewModel)
    }

    func makeOnboardingViewController(token: String?, coordinator: AuthCoordinator) -> OnboardingViewControllerable {
        let viewModel = self.makeOnboardingViewModel(coordinator: coordinator)
        viewModel.setKakaoAccessToken(token)
        return OnboardingViewController(viewModel: viewModel)
    }
    
}
