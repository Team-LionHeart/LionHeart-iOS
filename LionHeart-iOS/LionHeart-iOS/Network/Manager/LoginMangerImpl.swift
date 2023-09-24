//
//  LoginMangerImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

final class LoginMangerImpl: LoginManager {

    private let authService: AuthUserInService
    
    init(authService: AuthUserInService) {
        self.authService = authService
    }
    
    func login(type: LoginType, kakaoToken: String) async throws {
        try await authService.login(type: type, kakaoToken: kakaoToken)
    }
}
