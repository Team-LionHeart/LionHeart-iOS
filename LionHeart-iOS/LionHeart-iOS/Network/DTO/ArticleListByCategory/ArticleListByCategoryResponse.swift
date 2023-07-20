//
//  ArticleListByCategoryResponse.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/20.
//

import Foundation

struct CategoryList: DTO, Response {
    let categoryArticles: [ArticleListByCategoryResponse]?
}

struct ArticleListByCategoryResponse: DTO, Response {
    let articleId: Int
    let title: String
    let mainImageUrl: String
    let firstBodyContent: String
    let requiredTime: Int
    let isMarked: Bool
    let tags: [String]
}
