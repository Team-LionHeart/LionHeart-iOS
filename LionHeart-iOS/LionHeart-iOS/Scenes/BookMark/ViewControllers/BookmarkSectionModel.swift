//
//  BookmarkSectionModel.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/11/20.
//

import Foundation

enum BookmarkRow: Hashable {
    case detail(nickname: String)
    case list(articleList: ArticleSummaries)
}

struct BookmarkSectionModel {
    let detailData: [BookmarkRow]
    let listData: [BookmarkRow]
}
