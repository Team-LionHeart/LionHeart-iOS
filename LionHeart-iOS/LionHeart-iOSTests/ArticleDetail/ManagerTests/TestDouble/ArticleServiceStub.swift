//
//  ArticleServiceStub.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 3/12/24.
//

import Foundation
@testable import LionHeart_iOS

final class ArticleServiceStub: ArticleService {
    func inquiryTodayArticle() async throws -> LionHeart_iOS.TodayArticleResponse? {
        TodayArticleResponse(
            babyNickname: "string",
            title: "string",
            mainImageUrl: "string",
            editorNoteContent: "string",
            week: 0,
            day: 0,
            articleId: 0
        )
    }
    
    func getArticleDetail(articleId: Int) async throws -> LionHeart_iOS.ArticleDetail? {
        ArticleDetail(
            title: "string",
            author: "string",
            mainImageUrl: "string",
            mainImageCaption: "string",
            isMarked: true,
            contents: [
                ArticleBlock(type: "EDITOR_NOTE",
                             content: "string",
                             caption: "string")
            ]
        )
    }
    
    func getArticleListByCategory(categoryString: String) async throws -> LionHeart_iOS.CategoryList? {
        CategoryList(
            articleSummaries: [
                .init(articleId: 0,
                      title: "string",
                      mainImageUrl: "string",
                      firstBodyContent: "string",
                      requiredTime: 0,
                      isMarked: true,
                      tags: ["string"])
            ]
        )
    }
    
    
}
