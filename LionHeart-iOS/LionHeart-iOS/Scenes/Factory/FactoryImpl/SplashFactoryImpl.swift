//
//  SplashFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct SplashFactoryImpl: SplashFactory {
    func makeSplashViewController() -> SplashViewControllerable {
        return SplashViewController(manager: SplashManagerImpl(authService: AuthServiceImpl(apiService: APIService())))
    }
}
