//
//  AuthServiceWrapper.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/09/07.
//

import Foundation

final class AuthMyPageServiceWrapper: AuthServiceProtocol, MyPageServiceProtocol {
    
    let authAPIService: AuthProtocol = AuthAPI(apiService: APIService())
    
    func getMyPage() async throws -> MyPageAppData {
        let urlRequest = try NetworkRequest(path: "/v1/member/profile", httpMethod: .get).makeURLRequest(isLogined: true)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: MyPageResponse.self)
        guard let model else { return .init(badgeImage: "", nickname: "", isAlarm: "") }
        return MyPageAppData(badgeImage: model.level,
                             nickname: model.babyNickname,
                             isAlarm: model.notificationStatus)
    }
    
    func reissueToken(token: Token) async throws -> Token? {
        let model = try await authAPIService.reissueToken(token: token)
        return model
    }
    
    func login(type: LoginType, kakaoToken: String) async throws {
        let model = try await authAPIService.login(type: type, kakaoToken: kakaoToken)
        UserDefaultsManager.tokenKey?.accessToken = model?.accessToken
        UserDefaultsManager.tokenKey?.refreshToken = model?.refreshToken
        return
    }
    
    func signUp(type: LoginType, onboardingModel: UserOnboardingModel) async throws {
        let model = try await authAPIService.signUp(type: type, onboardingModel: onboardingModel)
        UserDefaultsManager.tokenKey?.accessToken = model?.accessToken
        UserDefaultsManager.tokenKey?.refreshToken = model?.refreshToken
        return
    }
    
    func resignUser() async throws {
        try await authAPIService.resignUser()
    }
    
    func logout(token: UserDefaultToken) async throws {
        try await authAPIService.logout(token: token)
    }
    
}

extension AuthMyPageServiceWrapper: Serviceable {}
