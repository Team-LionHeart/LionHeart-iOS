//
//  ChallengeAPI.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/23.
//

//import Foundation
//
//protocol ChallengeServiceAPIProtocol {
//    func inquireChallengeInfo() async throws -> ChallengeDataResponse?
//}
//
//final class ChallengeAPI: ChallengeServiceAPIProtocol {
//    
//    private let apiService: Requestable
//    
//    init(apiService: Requestable) {
//        self.apiService = apiService
//    }
//    
//    func inquireChallengeInfo() async throws -> ChallengeDataResponse? {
//        let urlRequest = try NetworkRequest(path: "/v1/challenge/progress", httpMethod: .get).makeURLRequest(isLogined: true)
//        return try await apiService.request(urlRequest)
//    }
//}
