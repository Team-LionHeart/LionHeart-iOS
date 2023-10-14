//
//  ArticleDetailManager.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol ArticleDetailManager {
    func getArticleDetail(articleId: Int) async throws -> [BlockTypeAppData]
    func postBookmark(model: BookmarkRequest) async throws
}
