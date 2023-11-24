//
//  BookmarkModel.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/15.
//

import Foundation

struct BookmarkAppData: AppData, Hashable {
    let nickName: String
    var articleSummaries: [ArticleSummaries]
}

extension BookmarkAppData {
    static var empty: Self {
        return .init(nickName: "", articleSummaries: [])
    }
}
