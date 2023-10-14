//
//  ArticleListByCategoryManager.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol ArticleListByCategoryManager {
    func getArticleListByCategory(categoryString: String) async throws -> CurriculumWeekData
    func postBookmark(model: BookmarkRequest) async throws
}
