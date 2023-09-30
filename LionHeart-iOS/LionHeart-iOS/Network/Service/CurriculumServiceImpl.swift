//
//  CurriculumServiceImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

protocol CurriculumService {
    func getArticleListByWeekInfo(week: Int) async throws -> CurriculumListByWeekResponse?
    func getCurriculumServiceInfo() async throws -> CurriculumResponse?
}

final class CurriculumServiceImpl: CurriculumService {
    
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func getArticleListByWeekInfo(week: Int) async throws -> CurriculumListByWeekResponse? {
        let urlRequest = try NetworkRequest(path: "v1/article/week/\(week)", httpMethod: .get).makeURLRequest(isLogined: true)
        return try await apiService.request(urlRequest)
    }
    
    func getCurriculumServiceInfo() async throws -> CurriculumResponse? {
        let urlRequest = try NetworkRequest(path: "/v1/curriculum/progress", httpMethod: .get).makeURLRequest(isLogined: true)
        return try await apiService.request(urlRequest)
    }
}
