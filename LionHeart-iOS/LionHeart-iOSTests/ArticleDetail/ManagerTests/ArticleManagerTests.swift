//
//  ArticleManagerTests.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 3/12/24.
//

import XCTest
@testable import LionHeart_iOS

final class ArticleManagerTests: XCTestCase {

    var articleService: ArticleServiceStub!
    var bookmarkService: BookmarkServiceSpy!
    var articleManager: ArticleDetailManagerImpl!
        
    override func setUp() {
        self.articleService = ArticleServiceStub()
        self.bookmarkService = BookmarkServiceSpy()
        self.articleManager = ArticleDetailManagerImpl(
            articleService: self.articleService,
            bookmarkService: self.bookmarkService
        )
        
    }
    
    override func tearDown() {
        self.articleService = nil
        self.bookmarkService = nil
        self.articleManager = nil
    }

    func test_ArticleDetail_AppData로_변환() async throws {
        // Given
        
        // When
        let result = try await self.articleManager.getArticleDetail(articleId: 0)
        // Then
        XCTAssertEqual(result.count, 4)
    }
    
    func test_북마크를_저장한다() async throws {
        // Given
        let request = BookmarkRequest(articleId: 0, bookmarkRequestStatus: true)
        
        // When
        try await self.articleManager.postBookmark(model: request)
        
        // Then
        XCTAssertTrue(self.bookmarkService.isPosted)
    }

}
