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

    func refreshingToken(token: Token) async throws -> Token? {

        let params = token.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: params, options: [])

        let urlRequest = try NetworkRequest(path: "/v1/auth/reissue", httpMethod: .post, body: body)
            .makeURLRequest(isLogined: false)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)

        let model = try handleErrorCode(data: data, decodeType: Token.self)

        return model
    }

    func logout(token: Token) async throws {
        // MARK: - 최종 코드
        let urlRequest = try NetworkRequest(path: "/v1/auth/logout", httpMethod: .post)
            .makeURLRequest(isLogined: true)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)

        try handleErrorCode(data: data, decodeType: String.self)
    }



}
