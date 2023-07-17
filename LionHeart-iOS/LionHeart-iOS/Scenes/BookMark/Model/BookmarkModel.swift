//
//  BookmarkModel.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/15.
//

import Foundation

struct BookmarkAppData: AppData {
    let nickName: String?
    let articleSummaries: [ArticleSummaries]?
}

struct ArticleSummaries: AppData {
    let title: String
    let articleImage: String
    let bookmarked: Bool
    let tags: [String]
}
