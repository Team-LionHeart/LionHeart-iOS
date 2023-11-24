//
//  ArticleSummaries.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/24.
//

import Foundation

struct ArticleSummaries: AppData, Hashable {
    let title: String
    let articleID: Int
    let articleImage: String
    let bookmarked: Bool
    let tags: [String]
}

extension ArticleSummaries {
    static let empty = ArticleSummaries(title: "empty", articleID: 0, articleImage: "", bookmarked: false, tags: [])
}
