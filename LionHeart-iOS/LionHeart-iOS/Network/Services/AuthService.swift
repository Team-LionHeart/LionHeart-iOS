//
//  AuthService.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/13.
//

import UIKit

protocol UserInProtocol {
    func reissueToken(token: Token) async throws -> Token?
    func login(type: LoginType, kakaoToken: String) async throws
    func signUp(type: LoginType, onboardingModel: UserOnboardingModel) async throws
}

protocol UserOutProtocol {
    func resignUser() async throws
    func logout(token: UserDefaultToken) async throws
}

protocol AuthServiceProtocol: UserInProtocol, UserOutProtocol {}
