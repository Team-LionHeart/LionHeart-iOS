//
//  ArticleListByCategoryMangerImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

final class ArticleListByCategoryMangerImpl: ArticleListByCategoryManager {
    
    private let articleService: ArticleService
    private let bookmarkService: BookmarkService
    
    init(articleService: ArticleService, bookmarkService: BookmarkService) {
        self.articleService = articleService
        self.bookmarkService = bookmarkService
    }
    
    func getArticleListByCategory(categoryString: String) async throws -> CurriculumWeekData {
        guard let model = try await articleService.getArticleListByCategory(categoryString: categoryString) else { throw NetworkError.badCasting }
        return model.toAppData()
    }
    
    func postBookmark(model: BookmarkRequest) async throws {
        guard let data = try await bookmarkService.postBookmark(model: model) else { throw NetworkError.badCasting }
        print(data)
    }
}
