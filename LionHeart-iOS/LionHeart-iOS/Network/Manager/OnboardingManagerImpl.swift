//
//  OnboardingManagerImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

final class OnboardingManagerImpl: OnboardingManager {
    
    private let authService: AuthUserInService
    
    init(authService: AuthUserInService) {
        self.authService = authService
    }
    
    func signUp(type: LoginType, onboardingModel: UserOnboardingModel) async throws {
        try await authService.signUp(type: type, onboardingModel: onboardingModel)
    }
}
