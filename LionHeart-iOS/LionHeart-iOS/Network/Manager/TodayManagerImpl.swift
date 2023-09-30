//
//  TodayManagerImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

final class TodayManagerImpl: TodayManager {
    
    private let articleService: ArticleService
    
    init(articleService: ArticleService) {
        self.articleService = articleService
    }
    
    func inquiryTodayArticle() async throws -> TodayArticle {
        guard let model = try await articleService.inquiryTodayArticle() else { return .emptyArticle }
        return model.toAppData()
    }
}
