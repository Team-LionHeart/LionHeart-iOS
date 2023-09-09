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
        let params = token.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: params, options: [])

        let urlRequest = try NetworkRequest(path: "/v1/auth/reissue", httpMethod: .post, body: body)
            .makeURLRequest(isLogined: false)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: Token.self)
        
//        let model = try await authAPIService.reissueToken(token: token)
        
        return model
    }
    
    func login(type: LoginType, kakaoToken: String) async throws {
        // 1. UserDefault에서 토큰 가져오기
        guard let fcmToken = UserDefaultsManager.tokenKey?.fcmToken else {
            throw NetworkError.clientError(code: "", message: "\(UserDefaultsManager.tokenKey)")
        }
        let loginRequest = LoginRequest(socialType: type.raw, token: kakaoToken, fcmToken: fcmToken)
        
        // 2. 로그인 에 필요한 body 만들기
        let param = loginRequest.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        
        // 3. URLRequest 만들기
        let urlRequest = try NetworkRequest(path: "/v1/auth/login", httpMethod: .post, body: body).makeURLRequest(isLogined: false)
        
        // 4. 서버 통신
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        // 5. decode해온 response 받기 + 에러 던지기
        let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: Token.self)
        
        UserDefaultsManager.tokenKey?.accessToken = model?.accessToken
        UserDefaultsManager.tokenKey?.refreshToken = model?.refreshToken
        
        return
    }
    
    func signUp(type: LoginType, onboardingModel: UserOnboardingModel) async throws {
        guard let fcmToken = UserDefaultsManager.tokenKey?.fcmToken,
              let kakaoToken = onboardingModel.kakaoAccessToken,
              let pregnantWeeks = onboardingModel.pregnacny,
              let babyNickname = onboardingModel.fetalNickname  else { return }
        
        let requestModel = SignUpRequest(socialType: type.raw, token: kakaoToken, fcmToken: fcmToken, pregnantWeeks: pregnantWeeks, babyNickname: babyNickname)
        
        let param = requestModel.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        
        let urlRequest = try NetworkRequest(path: "/v1/auth/signup", httpMethod: .post, body: body).makeURLRequest(isLogined: false)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: Token.self)
        
        UserDefaultsManager.tokenKey?.accessToken = model?.accessToken
        UserDefaultsManager.tokenKey?.refreshToken = model?.refreshToken
        
        return
    }
    
    func resignUser() async throws {
//        let urlRequest = try NetworkRequest(path: "/v1/member", httpMethod: .delete).makeURLRequest(isLogined: true)
//        _ = try await URLSession.shared.data(for: urlRequest)
//        UserDefaultsManager.tokenKey?.refreshToken = nil
        try await authAPIService.resignUser()
    }
    
    func logout(token: UserDefaultToken) async throws {
        // MARK: - 최종 코드
        let urlRequest = try NetworkRequest(path: "/v1/auth/logout", httpMethod: .post)
            .makeURLRequest(isLogined: true)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)

        try dataDecodeAndhandleErrorCode(data: data, decodeType: String.self)
    }
    
}

extension AuthMyPageServiceWrapper: Serviceable {}
