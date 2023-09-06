//
//  AuthServiceWrapper.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/09/07.
//

import Foundation


typealias AuthMyPageServiceWrapperProtocol = MyPageServiceProtocol & AuthServiceProtocol

final class AuthMyPageServiceWrapper: AuthMyPageServiceWrapperProtocol {

    private let myPageService: MyPageServiceProtocol

    private let authService: AuthServiceProtocol

    init(myPageService: MyPageServiceProtocol, authService: AuthServiceProtocol) {
        self.myPageService = myPageService
        self.authService = authService
    }

    func resign() async throws {
        try await authService.resignUser()
    }

    func getMyPage() async throws -> MyPageAppData {
        return try await myPageService.getMyPage()
    }

    func reissueToken(token: Token) async throws -> Token? {
        return try await authService.reissueToken(token: token)
    }

    func logout(token: UserDefaultToken) async throws {
        try await authService.logout(token: token)
    }

    func login(type: LoginType, kakaoToken: String) async throws {
        try await authService.login(type: type, kakaoToken: kakaoToken)
    }

    func signUp(type: LoginType, onboardingModel: UserOnboardingModel) async throws {
        try await authService.signUp(type: type, onboardingModel: onboardingModel)
    }

    func resignUser() async throws {
        try await authService.resignUser()
    }
}
