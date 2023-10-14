//
//  OnboardingManager.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol OnboardingManager {
    func signUp(type: LoginType, onboardingModel: UserOnboardingModel) async throws
}
