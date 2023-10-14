//
//  SplashManager.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol SplashManager {
    func reissueToken(token: Token) async throws -> Token?
    func logout(token: UserDefaultToken) async throws
}
