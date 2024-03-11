//
//  BookmarkServiceStub.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 3/12/24.
//

import Foundation
@testable import LionHeart_iOS


final class BookmarkServiceSpy: BookmarkService {
    
    var isPosted = false
    
    func getBookmark() async throws -> LionHeart_iOS.BookmarkResponse? {
        BookmarkResponse(
            babyNickname: "string",
            articleSummaries: [
                ArticleSummaryDTO(title: "string", articleId: 0, mainImageUrl: "string", isMarked: true, tags: ["string"])
            ])
    }
    
    func postBookmark(model: LionHeart_iOS.BookmarkRequest) async throws -> String? {
        self.isPosted = true
        return "success"
    }
    
    
}
