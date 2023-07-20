//
//  ArticleListByCategoryResponse.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/20.
//

import Foundation

struct CategoryList: DTO, Response {
    let categoryArticles: [ArticleListByCategoryResponse]
}

struct ArticleListByCategoryResponse: DTO, Response {
    let articleId: Int
    let title: String
    let mainImageUrl: String
    let firstBodyContent: String
    let requiredTime: Int
    let isMarked: Bool
    let tags: [String]
}

extension CategoryList {
    func toAppData() -> CurriculumWeekData {

        let articles = self.categoryArticles.map { response in
            return ArticleDataByWeek(articleId: response.articleId,
                                     articleTitle: response.title,
                                     articleImage: response.mainImageUrl,
                                     articleContent: response.firstBodyContent,
                                     articleReadTime: response.requiredTime,
                                     isArticleBookmarked: response.isMarked,
                                     articleTags: response.tags)
        }


        return CurriculumWeekData(articleData: articles, week: nil)
    }
}
