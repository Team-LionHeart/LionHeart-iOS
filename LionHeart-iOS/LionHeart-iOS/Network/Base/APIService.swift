//
//  APIService.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/08.
//

import Foundation

protocol Requestable {
    func request<T: Decodable>(_ request: URLRequest) async throws -> T?
}

protocol LHURLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: LHURLSession {}

final class APIService: Requestable {
    
    private let session: LHURLSession
    
    init(session: LHURLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ request: URLRequest) async throws -> T? {
        let (data, _) = try await session.data(for: request)
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(BaseResponse<T>.self, from: data) else {
            throw NetworkError.jsonDecodingError
        }
        
        let statusCode = decodedData.code
        guard !NetworkErrorCode.clientErrorCode.contains(statusCode) else {
            throw NetworkError.clientError(code: decodedData.code, message: decodedData.message)
        }

        guard !NetworkErrorCode.serverErrorCode.contains(statusCode) else {
            throw NetworkError.serverError
        }
        
        print("✨✨✨✨✨✨✨✨✨✨✨✨✨API호출성공✨✨✨✨✨✨✨✨✨✨✨✨✨")
        print(decodedData)
        return decodedData.data
    }
}
