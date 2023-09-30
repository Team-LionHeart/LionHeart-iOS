//
//  BookmarkModel.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/15.
//

import Foundation

struct BookmarkAppData: AppData {
    let nickName: String
    let articleSummaries: [ArticleSummaries]
}

extension BookmarkAppData {
    static var empty: Self {
        return .init(nickName: "", articleSummaries: [])
    }
}

struct ArticleSummaries: AppData {
    let title: String
    let articleID: Int
    let articleImage: String
    let bookmarked: Bool
    let tags: [String]
}
