//
//  MyPageAPI.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/10.
//

import Foundation

protocol MyPageProtocol {
    func getMyPage() async throws -> MyPageResponse?
}

class MyPageAPI: MyPageProtocol {
    
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func getMyPage() async throws -> MyPageResponse? {
        let urlRequest = try NetworkRequest(path: "/v1/member/profile", httpMethod: .get).makeURLRequest(isLogined: true)
        return try await apiService.request(urlRequest)
    }
}
