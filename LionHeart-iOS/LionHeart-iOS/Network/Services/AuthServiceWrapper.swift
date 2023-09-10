//
//  AuthServiceWrapper.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/09/07.
//

import Foundation

final class AuthMyPageServiceWrapper: AuthServiceProtocol, MyPageServiceProtocol {
    
    private let authAPIService: AuthAPIProtocol
    private let mypageAPIService: MyPageAPIProtocol
    
    init(authAPIService: AuthAPIProtocol, mypageAPIService: MyPageAPIProtocol) {
        self.authAPIService = authAPIService
        self.mypageAPIService = mypageAPIService
    }
    
    func getMyPage() async throws -> MyPageAppData {
        let model = try await mypageAPIService.getMyPage()
        guard let model else { return MyPageAppData.empty }
        return MyPageAppData(badgeImage: model.level, nickname: model.babyNickname, isAlarm: model.notificationStatus)
    }
    
    func reissueToken(token: Token) async throws -> Token? {
        let model = try await authAPIService.reissueToken(token: token)
        return model
    }
    
    func login(type: LoginType, kakaoToken: String) async throws {
        try await authAPIService.login(type: type, kakaoToken: kakaoToken)
    }
    
    func signUp(type: LoginType, onboardingModel: UserOnboardingModel) async throws {
        try await authAPIService.signUp(type: type, onboardingModel: onboardingModel)
    }
    
    func resignUser() async throws {
        try await authAPIService.resignUser()
    }
    
    func logout(token: UserDefaultToken) async throws {
        try await authAPIService.logout(token: token)
    }
    
}

extension AuthMyPageServiceWrapper: Serviceable {}
