//
//  BookmarkRequest.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/18.
//

import Foundation

struct BookmarkRequest: DTO, Request {
    let articleId: Int
    let bookmarkStatus: Bool
}
