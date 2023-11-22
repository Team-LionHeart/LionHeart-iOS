//
//  BookmarkModel.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/15.
//

import Foundation

struct BookmarkAppData: AppData {
    let nickName: String
    var articleSummaries: [ArticleSummaries]
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

extension ArticleSummaries {
    static let empty = ArticleSummaries(title: "empty", articleID: 0, articleImage: "", bookmarked: false, tags: [])
}
