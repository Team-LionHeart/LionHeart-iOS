//
//  CurriculumResponse.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/19.
//

import Foundation

struct CurriculumResponse: DTO, Response {
    let week: Int
    let day: Int
    let progress: Int
    let remainingDay: Int
}

struct CurriculumListByWeekResponse: DTO, Response {
    let articleSummaries: [CategoryArticle]
}

struct CategoryArticle: Response {
    let articleId: Int
    let title: String
    let mainImageUrl: String
    let firstBodyContent: String
    let requiredTime: Int
    let isMarked: Bool
    let tags: [String]
}

/// CurriculumListByWeekResponse -> [ArticleDataByWeek]
extension CurriculumListByWeekResponse {
    func toAppData() -> [ArticleDataByWeek] {
        return self.articleSummaries.map { article in
            ArticleDataByWeek(articleId: article.articleId, articleTitle: article.title, articleImage: article.mainImageUrl, articleContent: article.firstBodyContent, articleReadTime: article.requiredTime, isArticleBookmarked: article.isMarked, articleTags: article.tags)
        }
    }
}
