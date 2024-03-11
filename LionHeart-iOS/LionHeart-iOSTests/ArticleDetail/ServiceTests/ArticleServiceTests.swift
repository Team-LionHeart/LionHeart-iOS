//
//  ArticleServiceTests.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 3/11/24.
//

import XCTest
import UIKit
import Combine
@testable import LionHeart_iOS

final class ArticleServiceTests: XCTestCase {
    
    var jsonLoader: JSONLoader!
    
    override func setUp() {
        jsonLoader = JSONLoader()
    }
    
    override func tearDown() {
        jsonLoader = nil
    }
    
    func test_Today_article_데이터를_가져온다() async throws {
        // Given
        let apiService = try self.setAPIService(fileName: "TodayArticleGET")
        let articleService = ArticleServiceImpl(apiService: apiService)
        let expectation = TodayArticleResponse(
            babyNickname: "minjae",
            title: "TITLE",
            mainImageUrl: "string",
            editorNoteContent: "editornote",
            week: 0,
            day: 0,
            articleId: 0
        )
        
        // When
        let response = try await articleService.inquiryTodayArticle()
        
        // Then
        let result = try XCTUnwrap(response)
        XCTAssertEqual(expectation, result)
    }
    
    func test_Article_상세_데이터를_가져온다() async throws {
        // Given
        let apiService = try self.setAPIService(fileName: "ArticleDetailGET")
        let articleService = ArticleServiceImpl(apiService: apiService)
        let expectation = ArticleDetail(
            title: "string",
            author: "string",
            mainImageUrl: "string",
            mainImageCaption: "string",
            isMarked: true,
            contents: [
                ArticleBlock(type: "EDITOR_NOTE",
                             content: "string",
                             caption: "string")
            ]
        )
        
        
        // When
        let response = try await articleService.getArticleDetail(articleId: 0)
        
        // Then
        let result = try XCTUnwrap(response)
        XCTAssertEqual(expectation, result)
    }
    
    func test_Article_카테고리_데이터를_가져온다() async throws {
        // Given
        let apiService = try self.setAPIService(fileName: "AritleByCategoryGET")
        let articleService = ArticleServiceImpl(apiService: apiService)
        let expectation = CategoryList(
            articleSummaries: [
                .init(articleId: 0,
                      title: "string",
                      mainImageUrl: "string",
                      firstBodyContent: "string",
                      requiredTime: 0,
                      isMarked: true,
                      tags: ["string"])
            ]
        )
        
        // When
        let response = try await articleService.getArticleListByCategory(categoryString: "")
        
        // Then
        let result = try XCTUnwrap(response)
        XCTAssertEqual(expectation, result)
    }
    
}

extension ArticleServiceTests {
    private func setAPIService(fileName: String) throws -> APIService {
        let fileURL = jsonLoader.load(fileName: fileName)
        let data = try Data(contentsOf: fileURL)
        let urlSessionStub = URLSessionStub(data: data)
        let apiService = APIService(session: urlSessionStub)
        return apiService
    }
}
