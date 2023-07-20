//
//  CurriculumListByWeekData.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/14.
//

import UIKit

struct CurriculumWeekData: AppData {
    var articleData: [ArticleDataByWeek]
    let week: Int?
}

struct ArticleDataByWeek: AppData {
    let articleId: Int
    let articleTitle: String
    let articleImage: String
    let articleContent: String
    let articleReadTime: Int
    var isArticleBookmarked: Bool
    let articleTags: [String]
}

extension ArticleDataByWeek {
    static var emptyData = ArticleDataByWeek(articleId: 0, articleTitle: "", articleImage: "", articleContent: "", articleReadTime: 0, isArticleBookmarked: false, articleTags: [])
}

