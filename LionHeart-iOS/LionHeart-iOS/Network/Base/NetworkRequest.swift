//
//  NetworkRequest.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/14.
//

import Foundation

struct NetworkRequest {
    let path: String
    let httpMethod: HttpMethod
    let query: Request?
    let body: Data?
    let header: [String: String]?

    init(path: String, httpMethod: HttpMethod, query: Request? = nil, body: Data? = nil, header: [String : String]? = nil) {
        self.path = path
        self.httpMethod = httpMethod
        self.query = query
        self.body = body
        self.header = header
    }

    func makeURLRequest(isLogined: Bool) throws -> URLRequest {
        var urlComponents = URLComponents(string: Config.baseURL)

        if let query = self.query {
            let queries = query.toDictionary()
            let queryItemArray = queries.map {
                return URLQueryItem(name: $0.key, value: "\($0.value)")
            }
            urlComponents?.queryItems = queryItemArray
        }

        guard let urlRequestURL = urlComponents?.url?.appendingPathComponent(self.path) else {
            throw NetworkError.urlEncodingError
        }

        var urlRequest = URLRequest(url: urlRequestURL)
        urlRequest.httpMethod = self.httpMethod.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

        if isLogined {
            guard let token = UserDefaultsManager.tokenKey?.accessToken else {
                throw NetworkError.clientError(code: "", message: "알 수 없는 에러: 회원가입까지 마쳤는데 JWT가 저장되있지 않는 상태")
            }
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }

        urlRequest.httpBody = self.body

        return urlRequest
    }

}
