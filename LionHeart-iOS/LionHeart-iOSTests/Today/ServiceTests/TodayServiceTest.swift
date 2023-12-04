//
//  TodayServiceTest.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 11/30/23.
//

import XCTest
import UIKit
import Combine
@testable import LionHeart_iOS

final class TodayServiceTest: XCTestCase {
    
    var manager: TodayManager!
    var jsonLoader: JSONLoader!
    
    override func setUp() {
        jsonLoader = JSONLoader()
    }
    
    override func tearDown() {
        manager = nil
        jsonLoader = nil
    }

    func test_투데이_아티클_조회_API_성공() async throws {
        do {
            // Given
            manager = try self.setManager(fileName: "TodayArticleSuccess")
            
            // When
            let result = try await manager.inquiryTodayArticle()
            
            let expectation = TodayArticle(fetalNickname: "minjae",
                                           articleTitle: "TITLE",
                                           articleDescription: "editornote",
                                           currentWeek: 0,
                                           currentDay: 0,
                                           mainImageURL: "string",
                                           aticleID: 0)
            
            // Then
            XCTAssertEqual(result, expectation)
        } catch {
            XCTFail("Error occured: \(error)")
        }
    }

    func test_투데이_아티클_조회_API_서버에러() async throws {
        var networkError: NetworkError?
        do {
            // Given
            manager = try self.setManager(fileName: "TodayServerError")
            
            // When
            let _ = try await manager.inquiryTodayArticle()
            XCTFail("Server Error: 성공할 수 없는 케이스입니다.")
        } catch {
            let error = error as? NetworkError
            networkError = error
        }
        
        // Then
        let expectation = NetworkError.serverError
        XCTAssertEqual(networkError, expectation)
    }
    
    func test_투데이_아티클_조회_API_클라이언트에러() async throws {
        var networkError: NetworkError?
        do {
            // Given
            manager = try self.setManager(fileName: "TodayClientError")
            
            // When
            let _ = try await manager.inquiryTodayArticle()
            XCTFail("Server Error: 성공할 수 없는 케이스입니다.")
        } catch {
            let error = error as? NetworkError
            networkError = error
        }
        
        // Then
        XCTAssertEqual(networkError, NetworkError.clientError(code: "N003", message: "클라이언트 에러입니다."))
    }
}

extension TodayServiceTest {
    private func setManager(fileName: String) throws -> TodayManager {
        let fileURL = jsonLoader.load(fileName: fileName)
        let data = try Data(contentsOf: fileURL)
        let urlSessionStub = URLSessionStub(data: data)
        let apiService = APIService(session: urlSessionStub)
        let articleService = ArticleServiceImpl(apiService: apiService)
        let manager = TodayManagerImpl(articleService: articleService)
        return manager
    }
}
