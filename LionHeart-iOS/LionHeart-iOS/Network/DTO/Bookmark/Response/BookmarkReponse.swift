//
//  Bookmark.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/17.
//

import Foundation

struct BookmarkResponse: DTO, Response {
    let babyNickname: String
    let articleSummaries: [ArticleSummaryDTO]
}

struct ArticleSummaryDTO: DTO, Response {
    let title: String
    let articleId: Int
    let mainImageUrl: String
    let isMarked: Bool
    let tags: [String]
}
