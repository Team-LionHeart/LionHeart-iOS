//
//  AuthService.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/13.
//

import UIKit


final class AuthService: Serviceable {

    static let shared = AuthService()
    private init() {}

    func reissueToken(token: Token) async throws -> Token? {

        let params = token.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: params, options: [])

        let urlRequest = try NetworkRequest(path: "/v1/auth/reissue", httpMethod: .post, body: body)
            .makeURLRequest(isLogined: false)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)

        let model = try handleErrorCode(data: data, decodeType: Token.self)

        return model
    }

    func logout(token: UserDefaultToken) async throws {
        // MARK: - 최종 코드
        let urlRequest = try NetworkRequest(path: "/v1/auth/logout", httpMethod: .post)
            .makeURLRequest(isLogined: true)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)

        try handleErrorCode(data: data, decodeType: String.self)
    }

    func login(type: LoginType) async throws {
        // 1. UserDefault에서 토큰 가져오기
        let tokens = UserDefaultsManager.tokenKey
        guard let accessToken = tokens?.accessToken, let fcmToken = tokens?.fcmToken else {
            throw NetworkError.clientError(code: "", message: "알수없는에러(토큰이 왜없을까요?)")
        }
        let loginRequest = LoginRequest(socialType: type.raw, token: accessToken, fcmToken: fcmToken)
        
        // 2. 로그인 에 필요한 body 만들기
        let param = loginRequest.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        
        // 3. URLRequest 만들기
        let urlRequest = try NetworkRequest(path: "v1/auth/login", httpMethod: .post, body: body).makeURLRequest(isLogined: false)
        
        // 4. 서버 통신
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        // 5. decode해온 response 받기 + 에러 던지기
        let model = try handleErrorCode(data: data, decodeType: UserDefaultToken.self)
        
        UserDefaultsManager.tokenKey?.accessToken = model?.accessToken
        UserDefaultsManager.tokenKey?.refreshToken = model?.refreshToken
        
        return
    }
}

enum LoginType {
    case kakao
    case apple
    
    var raw: String {
        return "\(self)".uppercased()
    }
}

// UserDefault에 우리가 저장하는 구조체
struct UserDefaultToken: AppData, Codable {
    var refreshToken: String?
    var accessToken: String?
    let fcmToken: String
    
    var isExistJWT: Bool {
        return !(self.refreshToken == nil)
    }
}


// 로그인 API에 필요한 body 구조체
// Data transfer Object (서버 <-> 클라)
struct LoginRequest: DTO, Request {
    let socialType: String
    let token: String
    let fcmToken: String
}
