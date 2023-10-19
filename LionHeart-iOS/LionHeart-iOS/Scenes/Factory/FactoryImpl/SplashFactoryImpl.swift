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
    
    func makeSplashViewController(coordinator: SplashCoordinator) -> SplashViewControllerable {
        return SplashViewController(manager: SplashManagerImpl(authService: AuthServiceImpl(apiService: APIService())), adaptor: self.makeSplashAdaptor(coordinator: coordinator))
    }
}
