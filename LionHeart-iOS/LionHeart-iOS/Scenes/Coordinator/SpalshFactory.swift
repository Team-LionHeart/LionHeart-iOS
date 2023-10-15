//
//  SpalshFactory.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/15.
//

import UIKit

protocol SplashFactory {
    func makeSplashFactory() -> SplashViewControllerable
}

struct SplashFactoryImpl: SplashFactory {
    func makeSplashFactory() -> SplashViewControllerable {
        return SplashViewController(manager: SplashManagerImpl(authService: AuthServiceImpl(apiService: APIService())))
    }
}
