//
//  ArticleService.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/18.
//

import UIKit

final class ArticleService: Serviceable {
    static let shared = ArticleService()
    private init() {}
    
    func inquiryTodayArticle() async throws -> TodayArticle {
        let urlRequest = try NetworkRequest(path: "/v1/article/today", httpMethod: .get).makeURLRequest(isLogined: true)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let model = try handleErrorCode(data: data, decodeType: TodayArticleResponse.self)
        
        guard let model else {
            throw NetworkError.jsonDecodingError
        }
        
        return .init(fetalNickname: model.babyNickname, articleTitle: model.title, articleDescription: model.editorNoteContent, currentWeek: model.week, currentDay: model.day, mainImageURL: model.mainImageUrl, aticleID: model.articleId)
    }
}
