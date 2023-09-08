//
//  AuthAPI.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/08.
//

import Foundation

protocol AuthProtocol {
    func reissueToken(token: Token) async throws -> Token?
    func login(type: LoginType, kakaoToken: String) async throws -> Token?
    func signUp(type: LoginType, onboardingModel: UserOnboardingModel) async throws -> Token?
    func logout(token: UserDefaultToken) async throws -> String?
    func resignUser() async throws
}

struct AuthAPI: AuthProtocol {
    
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func reissueToken(token: Token) async throws -> Token? {
        let params = token.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: params, options: [])

        let urlRequest = try NetworkRequest(path: "/v1/auth/reissue", httpMethod: .post, body: body)
            .makeURLRequest(isLogined: false)
        let token: Token? = try await apiService.request(urlRequest)
        return token
    }
    
    func login(type: LoginType, kakaoToken: String) async throws -> Token? {
        guard let fcmToken = UserDefaultsManager.tokenKey?.fcmToken else {
            throw NetworkError.clientError(code: "", message: "\(UserDefaultsManager.tokenKey)")
        }
        let loginRequest = LoginRequest(socialType: type.raw, token: kakaoToken, fcmToken: fcmToken)
        
        // 2. 로그인 에 필요한 body 만들기
        let param = loginRequest.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        
        // 3. URLRequest 만들기
        let urlRequest = try NetworkRequest(path: "/v1/auth/login", httpMethod: .post, body: body).makeURLRequest(isLogined: false)
        
        return try await apiService.request(urlRequest)
    }
    
    func signUp(type: LoginType, onboardingModel: UserOnboardingModel) async throws -> Token? {
        guard let fcmToken = UserDefaultsManager.tokenKey?.fcmToken,
              let kakaoToken = onboardingModel.kakaoAccessToken,
              let pregnantWeeks = onboardingModel.pregnacny,
              let babyNickname = onboardingModel.fetalNickname  else { throw NetworkError.badCasting }
        
        let requestModel = SignUpRequest(socialType: type.raw, token: kakaoToken, fcmToken: fcmToken, pregnantWeeks: pregnantWeeks, babyNickname: babyNickname)
        
        let param = requestModel.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        
        let urlRequest = try NetworkRequest(path: "/v1/auth/signup", httpMethod: .post, body: body).makeURLRequest(isLogined: false)
        
        return try await apiService.request(urlRequest)
    }
    
    func logout(token: UserDefaultToken) async throws -> String? {
        let urlRequest = try NetworkRequest(path: "/v1/auth/logout", httpMethod: .post)
            .makeURLRequest(isLogined: true)
        
        return try await apiService.request(urlRequest)
    }
    
    func resignUser() async throws {
        let urlRequest = try NetworkRequest(path: "/v1/member", httpMethod: .delete).makeURLRequest(isLogined: true)
        _ = try await URLSession.shared.data(for: urlRequest)
        UserDefaultsManager.tokenKey?.refreshToken = nil
    }
    
    
}
