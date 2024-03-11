//
//  TodayArticleResponse.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/18.
//

import UIKit

struct TodayArticleResponse: DTO, Response, Equatable {
    let babyNickname: String
    let title: String
    let mainImageUrl: String
    let editorNoteContent: String
    let week: Int
    let day: Int
    let articleId: Int
}

extension TodayArticleResponse {
    func toAppData() -> TodayArticle {
        return .init(fetalNickname: self.babyNickname, articleTitle: self.title, articleDescription: self.editorNoteContent, currentWeek: self.week, currentDay: self.day, mainImageURL: self.mainImageUrl, aticleID: self.articleId)
    }
}
