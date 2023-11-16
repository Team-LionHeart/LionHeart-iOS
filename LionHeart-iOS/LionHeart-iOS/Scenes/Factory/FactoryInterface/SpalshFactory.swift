//
//  SpalshFactory.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/15.
//

import UIKit

protocol SplashFactory {
    func makeSplashViewModel(coordinator: SplashCoordinator) -> any SplashViewModel & SplashViewModelPresentable
    func makeSplashAdaptor(coordinator: SplashCoordinator) -> EntireSplashNavigation
    func makeSplashViewController(coordinator: SplashCoordinator) -> SplashViewControllerable
}


