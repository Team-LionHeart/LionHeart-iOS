//
//  ArticleDetailManagerImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

final class ArticleDetailManagerImpl: ArticleDetailManager {
    
    private let articleService: ArticleService
    private let bookmarkService: BookmarkService
    
    init(articleService: ArticleService, bookmarkService: BookmarkService) {
        self.articleService = articleService
        self.bookmarkService = bookmarkService
    }
    
    func getArticleDetail(articleId: Int) async throws -> [BlockTypeAppData] {
        guard let model = try await articleService.getArticleDetail(articleId: articleId) else { return []}
        return model.toAppData()
    }
    
    func postBookmark(model: BookmarkRequest) async throws {
        guard let data = try await bookmarkService.postBookmark(model: model) else { throw NetworkError.badCasting }
        print(data)
    }
}
