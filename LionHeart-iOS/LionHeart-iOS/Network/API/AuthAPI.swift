//
//  AuthAPI.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/08.
//

//import Foundation
//
//protocol AuthAPIProtocol {
//    func reissueToken(token: Token) async throws -> Token?
//    func login(type: LoginType, kakaoToken: String) async throws
//    func signUp(type: LoginType, onboardingModel: UserOnboardingModel) async throws
//    @discardableResult func logout(token: UserDefaultToken) async throws -> String?
//    func resignUser() async throws
//}
//
//final class AuthAPI: AuthAPIProtocol {
//    
//    private let apiService: Requestable
//    
//    init(apiService: Requestable) {
//        self.apiService = apiService
//    }
//    
//    func reissueToken(token: Token) async throws -> Token? {
//        let urlRequest = try makeReissueTokenUrlRequest(token: token)
//        return try await apiService.request(urlRequest)
//    }
//    
//    func login(type: LoginType, kakaoToken: String) async throws {
//        let urlRequest = try makeLoginUrlRequest(type: type, kakaoToken: kakaoToken)
//        userdefaultsSettingWhenUserIn(model: try await apiService.request(urlRequest))
//    }
//    
//    func signUp(type: LoginType, onboardingModel: UserOnboardingModel) async throws {
//        let urlRequest = try makeSignUpUrlRequest(type: type, onboardingModel: onboardingModel)
//        userdefaultsSettingWhenUserIn(model: try await apiService.request(urlRequest))
//    }
//    
//    func logout(token: UserDefaultToken) async throws -> String? {
//        let urlRequest = try makeLogoutUrlRequest()
//        return try await apiService.request(urlRequest)
//    }
//    
//    func resignUser() async throws {
//        let urlRequest = try makeResignUserUrlRequest()
//        _ = try await URLSession.shared.data(for: urlRequest)
//        UserDefaultsManager.tokenKey?.refreshToken = nil
//    }
//}
//
//extension AuthAPI {
//    private func userdefaultsSettingWhenUserIn(model: Token?) {
//        UserDefaultsManager.tokenKey?.accessToken = model?.accessToken
//        UserDefaultsManager.tokenKey?.refreshToken = model?.refreshToken
//    }
//}
//
//extension AuthAPI {
//    func makeResignUserUrlRequest() throws -> URLRequest {
//        return try NetworkRequest(path: "/v1/member", httpMethod: .delete).makeURLRequest(isLogined: true)
//    }
//    
//    func makeLogoutUrlRequest() throws -> URLRequest {
//        return try NetworkRequest(path: "/v1/auth/logout", httpMethod: .post).makeURLRequest(isLogined: true)
//    }
//    
//    func makeSignUpUrlRequest(type: LoginType, onboardingModel: UserOnboardingModel) throws -> URLRequest {
//        guard let fcmToken = UserDefaultsManager.tokenKey?.fcmToken,
//              let kakaoToken = onboardingModel.kakaoAccessToken,
//              let pregnantWeeks = onboardingModel.pregnacny,
//              let babyNickname = onboardingModel.fetalNickname  else { throw NetworkError.badCasting }
//        let requestModel = SignUpRequest(socialType: type.raw, token: kakaoToken, fcmToken: fcmToken, pregnantWeeks: pregnantWeeks, babyNickname: babyNickname)
//        let param = requestModel.toDictionary()
//        let body = try JSONSerialization.data(withJSONObject: param)
//        return try NetworkRequest(path: "/v1/auth/signup", httpMethod: .post, body: body).makeURLRequest(isLogined: false)
//    }
//    
//    func makeReissueTokenUrlRequest(token: Token) throws -> URLRequest {
//        let params = token.toDictionary()
//        let body = try JSONSerialization.data(withJSONObject: params, options: [])
//        return try NetworkRequest(path: "/v1/auth/reissue", httpMethod: .post, body: body)
//            .makeURLRequest(isLogined: false)
//    }
//    
//    func makeLoginUrlRequest(type: LoginType, kakaoToken: String) throws -> URLRequest {
//        guard let fcmToken = UserDefaultsManager.tokenKey?.fcmToken else {
//            throw NetworkError.clientError(code: "", message: "\(String(describing: UserDefaultsManager.tokenKey))")
//        }
//        let loginRequest = LoginRequest(socialType: type.raw, token: kakaoToken, fcmToken: fcmToken)
//        let param = loginRequest.toDictionary()
//        let body = try JSONSerialization.data(withJSONObject: param)
//        return try NetworkRequest(path: "/v1/auth/login", httpMethod: .post, body: body).makeURLRequest(isLogined: false)
//    }
//}
