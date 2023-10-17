//
//  AuthFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/15.
//

import Foundation

protocol AuthFactory {
    func makeLoginViewController(navigator: LoginNavigation) -> LoginViewControllerable
    func makeCompleteOnbardingViewController(navigator: CompleteOnbardingNavigation) -> CompleteOnbardingViewControllerable
    func makeOnboardingViewController(navigator: OnboardingNavigation) -> OnboardingViewControllerable
}


