//
//  SplashFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct SplashFactoryImpl: SplashFactory {
    
    func makeSplashAdaptor(coordinator: SplashCoordinator) -> EntireSplashNavigation {
        return SplashAdaptor(coordinator: coordinator)
    }
    
    func makeSplashViewModel(coordinator: SplashCoordinator) -> any SplashViewModel & SplashViewModelPresentable {
        let adaptor = self.makeSplashAdaptor(coordinator: coordinator)
        let apiService = APIService()
        let serviceImpl = AuthServiceImpl(apiService: apiService)
        let managerImpl = SplashManagerImpl(authService: serviceImpl)
        return SplashViewModelImpl(navigator: adaptor, manager: managerImpl)
    }
    
    func makeSplashViewController(coordinator: SplashCoordinator) -> SplashViewControllerable {
        let viewModel = self.makeSplashViewModel(coordinator: coordinator)
        return SplashViewController(viewModel: viewModel)
    }
}
