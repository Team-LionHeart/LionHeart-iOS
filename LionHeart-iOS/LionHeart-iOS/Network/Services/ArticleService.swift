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
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: TodayArticleResponse.self)
        else { return TodayArticle.emptyArticle }

        return .init(fetalNickname: model.babyNickname, articleTitle: model.title, articleDescription: model.editorNoteContent, currentWeek: model.week, currentDay: model.day, mainImageURL: model.mainImageUrl, aticleID: model.articleId)
    }

    func getArticleDetail(articleId: Int) async throws -> [BlockTypeAppData] {
        let urlRequest = try NetworkRequest(path: "/v1/article/1", httpMethod: .get).makeURLRequest(isLogined: true)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)

        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: ArticleDetail.self) else {
            return []
        }

        return model.toAppData()
    }
    
    func getArticleListByCategory(categoryString: String) async throws -> [ArticleListByCategoryAppData] {
        let urlRequest = try NetworkRequest(path: "/v1/article?category=\(categoryString)", httpMethod: .get).makeURLRequest(isLogined: true)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: CategoryArticle.self)
        
        var listData = [ArticleListByCategoryAppData]()
        
        model?.categoryArticles?.forEach {
            listData.append(ArticleListByCategoryAppData(articleID: $0.articleId, title: $0.title, mainImageURL: $0.mainImageUrl, articleDetailText: $0.firstBodyContent, requiredTime: $0.requiredTime, isMarked: $0.isMarked, tags: $0.tags))
        }
        
        return listData
    }
}
