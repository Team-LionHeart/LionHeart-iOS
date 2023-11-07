//
//  AuthFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/15.
//

import Foundation

protocol AuthFactory {
    func makeAuthAdaptor(coordinator: AuthCoordinator) -> EntireAuthNaviation
    func makeLoginViewController(coordinator: AuthCoordinator) -> LoginViewController
    func makeCompleteOnbardingViewController(coordinator: AuthCoordinator) -> CompleteOnbardingViewControllerable
    func makeOnboardingViewController(coordinator: AuthCoordinator) -> OnboardingViewControllerable
}


