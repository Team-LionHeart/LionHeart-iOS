//
//  ArticleListByCategoryAppData.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/20.
//

import Foundation

struct ArticleListByCategoryAppData: AppData {
    let articleID: Int
    let title: String
    let mainImageURL: String
    let articleDetailText: String
    let requiredTime: Int
    let isMarked: Bool
    let tags: [String]
}
