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

        /// 1. PATH 추가하고 원하는 URL만들기
        let urlComponents = URLComponents(string: Config.baseURL)
        let urlRequestURL = urlComponents?.url?.appendingPathComponent("/v1/auth/reissue")

        guard let url = urlRequestURL else {
            throw NetworkError.urlEncodingError
        }


        /// 2. Body에 필요한 정보 DATA로 encode
        let params = token.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: params, options: [])


        /// 3. URLRequest 만들기
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethod.post.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])

//        let urlRequest = try NetworkRequest(path: "/v1/auth/reissue", httpMethod: .post, body: body)
//            .makeURLRequest(isLogined: false)

        /// 4. 서버통신
        let (data, _) = try await URLSession.shared.data(for: urlRequest)

        /// 5. 에러 핸들링
        guard let tokenModel = try? JSONDecoder().decode(BaseResponse<Token>.self, from: data) else {
            throw NetworkError.jsonDecodingError
        }
        print("✨✨✨✨✨✨✨✨✨✨✨")
        dump(tokenModel)
        let statusCode = tokenModel.code
        guard !NetworkErrorCode.clientErrorCode.contains(statusCode) else {
            throw NetworkError.clientError(code: tokenModel.code, message: tokenModel.message)
        }

        guard !NetworkErrorCode.serverErrorCode.contains(statusCode) else {
            throw NetworkError.serverError
        }

        /// 6. 성공
        return tokenModel.data
    }

    func logout(token: Token) async throws {
        // MARK: - 최종 코드
        let urlRequest = try NetworkRequest(path: "/v1/auth/logout", httpMethod: .post)
            .makeURLRequest(isLogined: true)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)

        try handleErrorCode(data: data, decodeType: String.self)
        return
    }



}
