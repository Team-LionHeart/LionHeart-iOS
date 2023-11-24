//
//  ArticleDataByWeek.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/24.
//

import Foundation

struct ArticleDataByWeek: Hashable, AppData {
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
