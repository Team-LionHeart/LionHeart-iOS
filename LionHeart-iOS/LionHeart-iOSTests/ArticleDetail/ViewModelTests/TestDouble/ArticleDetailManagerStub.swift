//
//  ArticleDetailManagerStub.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 3/12/24.
//

import Foundation
@testable import LionHeart_iOS

final class ArticleDetailManagerStub: ArticleDetailManager {
    
    var isPosted = false
    
    func getArticleDetail(articleId: Int) async throws -> [LionHeart_iOS.BlockTypeAppData] {
        return [
            .thumbnail(isMarked: true, model: .init(content: "string", caption: "string"))
        ]
    }
    
    func postBookmark(model: LionHeart_iOS.BookmarkRequest) async throws {
        isPosted = true
    }
    
    
}
