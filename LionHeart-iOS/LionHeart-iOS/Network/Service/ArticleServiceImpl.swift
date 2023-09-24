//
//  ArticleServiceImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

struct Query: Request {
    let category: String
}

protocol ArticleService {
    func inquiryTodayArticle() async throws -> TodayArticleResponse?
    func getArticleDetail(articleId: Int) async throws -> ArticleDetail?
    func getArticleListByCategory(categoryString: String) async throws -> CategoryList?
}

final class ArticleServiceImpl: ArticleService {
    
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func inquiryTodayArticle() async throws -> TodayArticleResponse? {
        let urlRequest = try NetworkRequest(path: "/v1/article/today", httpMethod: .get).makeURLRequest(isLogined: true)
        return try await apiService.request(urlRequest)
    }

    func getArticleDetail(articleId: Int) async throws -> ArticleDetail? {
        let urlRequest = try NetworkRequest(path: "/v1/article/\(articleId)", httpMethod: .get).makeURLRequest(isLogined: true)
        return try await apiService.request(urlRequest)
    }
    
    func getArticleListByCategory(categoryString: String) async throws -> CategoryList? {
        let query = Query(category: categoryString)
        let urlRequest = try NetworkRequest(path: "/v1/article", httpMethod: .get, query: query).makeURLRequest(isLogined: true)
        return try await apiService.request(urlRequest)
    }
}
