//
//  CurriculumListManagerImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

final class CurriculumListManagerImpl: CurriculumListManager {
    
    private let bookmarkService: BookmarkService
    private let curriculumService: CurriculumService
    
    init(bookmarkService: BookmarkService, curriculumService: CurriculumService) {
        self.bookmarkService = bookmarkService
        self.curriculumService = curriculumService
    }
    
    func postBookmark(model: BookmarkRequest) async throws {
        guard let data = try await bookmarkService.postBookmark(model: model) else { throw NetworkError.badCasting }
        print(data)
    }
    
    func getArticleListByWeekInfo(week: Int) async throws -> CurriculumWeekData {
        guard let model = try await curriculumService.getArticleListByWeekInfo(week: week) else { throw NetworkError.badCasting }
        return model.toAppData()
    }
}
