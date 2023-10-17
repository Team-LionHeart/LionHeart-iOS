//
//  AuthAdaptor.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/17.
//

import Foundation

typealias AuthNaviation = LoginNavigation & OnboardingNavigation & CompleteOnbardingNavigation

final class AuthAdaptor: AuthNaviation {
    
    let coordinator: AuthCoordinator
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func checkUserIsVerified(userState: UserState, kakaoToken: String?) {
        self.coordinator.showTabbarOrOnboardingViewController(userState: userState, kakaoToken: kakaoToken)
    }
    
    func onboardingCompleted(data: UserOnboardingModel) {
        self.coordinator.showOnboardingCompleteViewController(data: data)
    }
    
    func startButtonTapped() {
        self.coordinator.showTabbarController()
    }
    
    func checkTokenIsExpired() {
        self.coordinator.exitApplication()
    }
    
    func backButtonTapped() {
        self.coordinator.pop()
    }
}
