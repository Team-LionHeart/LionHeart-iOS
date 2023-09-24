//
//  SplashManagerImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

final class SplashManagerImpl: SplashManager {
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func reissueToken(token: Token) async throws -> Token? {
        return try await authService.reissueToken(token: token)
    }
    
    func logout(token: UserDefaultToken) async throws {
        try await authService.logout(token: token)
    }
}
