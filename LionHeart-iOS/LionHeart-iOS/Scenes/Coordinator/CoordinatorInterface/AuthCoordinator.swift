//
//  AuthCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/17.
//

import Foundation

protocol AuthCoordinator: Coordinator {
    func showLoginViewController()
    func showTabbarController()
    func showCompleteOnboardingViewController(data: UserOnboardingModel)
    func showTabbarOrOnboardingViewController(userState: UserState, kakaoToken: String?)
    func pop()
    func exitApplication()
}
