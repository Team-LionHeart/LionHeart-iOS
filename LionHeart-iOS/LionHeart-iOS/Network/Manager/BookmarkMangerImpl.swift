//
//  BookmarkMangerImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

final class BookmarkMangerImpl: BookmarkManger {
    
    private let bookmarkService: BookmarkService
    
    init(bookmarkService: BookmarkService) {
        self.bookmarkService = bookmarkService
    }
    
    func getBookmark() async throws -> BookmarkAppData {
        guard let model = try await bookmarkService.getBookmark() else { return .empty }
        return model.toAppData()
    }
    
    func postBookmark(model: BookmarkRequest) async throws {
        guard let data = try await bookmarkService.postBookmark(model: model) else { throw NetworkError.badCasting }
        print(data)
    }
}
