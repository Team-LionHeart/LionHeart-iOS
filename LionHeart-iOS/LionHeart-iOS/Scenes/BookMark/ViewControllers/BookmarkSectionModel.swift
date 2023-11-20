//
//  BookmarkSectionModel.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/11/20.
//

import Foundation

enum BookmarkRow: Hashable {
    case detail(String)
    case list(ArticleSummaries)
}

struct BookmarkSectionModel {
    let detailData: [BookmarkRow]
    let listData: [BookmarkRow]
}
