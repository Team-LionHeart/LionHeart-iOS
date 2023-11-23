//
//  BookmarkSectionModel.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/11/22.
//

import Foundation

enum BookmarkRow: Hashable {
    case detail(nickname: String)
    case list(articleList: ArticleSummaries)
}
