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
    
    func getArticleListByCategory(categoryString: String) async throws -> ArticleListByCategoryAppData {
        let urlRequest = try NetworkRequest(path: "/v1/article/\(categoryString)", httpMethod: .get).makeURLRequest(isLogined: true)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: ArticleListByCategoryResponse.self)
        
        return ArticleListByCategoryAppData(articleID: model?.articleId,
                                            title: model?.title,
                                            mainImageURL: model?.mainImageUrl,
                                            articleDetailText: model?.firstBodyContent,
                                            requiredTime: model?.requiredTime, isMarked: model?.isMarked, tags: model?.tags)
    }
}
