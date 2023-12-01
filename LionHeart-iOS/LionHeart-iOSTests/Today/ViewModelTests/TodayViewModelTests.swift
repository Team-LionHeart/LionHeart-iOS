//
//  TodayViewModelTests.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 12/1/23.
//

import XCTest
import Combine

@testable import LionHeart_iOS


final class TodayViewModelTests: TodayViewModelSetUp {
    
    func test_투데이_아티클_조회_API_올바른데이터_성공() throws {
        // Given
        let expectation = XCTestExpectation(description: "Today Article API 성공적으로 Output으로 전달")
        
        manager.todayArticle = TodayArticle(fetalNickname: "Minjae",
                                            articleTitle: "title",
                                            articleDescription: "article description",
                                            currentWeek: 5,
                                            currentDay: 4,
                                            mainImageURL: "imageurl",
                                            aticleID: 1)
        
        let expectedOutput = TodayArticle(fetalNickname: "Minjae",
                                          articleTitle: "title",
                                          articleDescription: "article description",
                                          currentWeek: 5,
                                          currentDay: 4,
                                          mainImageURL: "imageurl",
                                          aticleID: 1)
        
        let input = TodayViewModelInput(viewWillAppearSubject: viewWillAppearSubject,
                                        navigationLeftButtonTapped: navigationLeftButtonTapped,
                                        navigationRightButtonTapped: navigationRightButtonTapped,
                                        todayArticleTapped: todayArticleTapped)

        let output = viewModel.transform(input: input)

        var result: TodayArticle!
        output.viewWillAppearSubject
            .sink { article in
                result = article
                expectation.fulfill()
            }
            .store(in: &cancelBag)

        // When
        viewWillAppearSubject.send(())

        wait(for: [expectation], timeout: 0.5)
        
        // Then
        XCTAssertEqual(result, expectedOutput)
    }
    
    func test_투데이_아티클_조회_API_데이터가_없을때() throws {
        // Given
        let expectation = XCTestExpectation(description: "Today Article API 성공적으로 Output으로 전달")
        
        manager.todayArticle = nil
        
        let expectedOutput = TodayArticle.emptyArticle
        
        let input = TodayViewModelInput(viewWillAppearSubject: viewWillAppearSubject,
                                        navigationLeftButtonTapped: navigationLeftButtonTapped,
                                        navigationRightButtonTapped: navigationRightButtonTapped,
                                        todayArticleTapped: todayArticleTapped)

        let output = viewModel.transform(input: input)

        var result: TodayArticle!
        output.viewWillAppearSubject
            .sink { article in
                result = article
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        // When
        viewWillAppearSubject.send(())

        wait(for: [expectation], timeout: 0.5)
        
        // Then
        XCTAssertEqual(result, expectedOutput)
    }
    
    func test_아티클_탭했을때_데이터전달_확인() {
        // Given
        
        let expectedArticleId = 1
        viewModel.articleID = expectedArticleId
        
        let expectation = XCTestExpectation(description: "아티클 Tapped")
        
        var articleID: Int!
        self.viewModel.navigationSubject
            .sink { flow in
                if case .articleTapped(let articleId) = flow {
                    articleID = articleId
                    self.navigation.todayArticleTapped(articleID: articleId)
                    expectation.fulfill()
                }
            }
            .store(in: &cancelBag)
        
        // When
        self.todayArticleTapped.send(())
        
        wait(for: [expectation], timeout: 0.3)
        
        // Then
        XCTAssertEqual(articleID, expectedArticleId)
        XCTAssertTrue(self.navigation.isTodayArticleTapped)
    }
    
    func test_네비게이션바_왼쪽버튼_북마크_데이터전달_확인() {
        // Given
        let expectation = XCTestExpectation(description: "네비게이션바 북마크 버튼 Tapped")
        
        var flowType: TodayViewModelImpl.FlowType!
        self.viewModel.navigationSubject
            .sink { flow in
                flowType = flow
                self.navigation.navigationLeftButtonTapped()
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        // When
        self.navigationLeftButtonTapped.send(())
        
        wait(for: [expectation], timeout: 0.3)
        
        // Then
        XCTAssertEqual(flowType, .bookmarkButtonTapped)
        XCTAssertTrue(self.navigation.isNaviLeftButtonTapped)
    }
    
    func test_네비게이션바_오른쪽버튼_마이페이지_데이터전달_확인() {
        // Given
        let expectation = XCTestExpectation(description: "네비게이션바 마이페이지 버튼 Tapped")
        
        var flowType: TodayViewModelImpl.FlowType!
        self.viewModel.navigationSubject
            .sink { flow in
                flowType = flow
                self.navigation.navigationRightButtonTapped()
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        // When
        self.navigationRightButtonTapped.send(())
        
        wait(for: [expectation], timeout: 0.3)
        
        // Then
        XCTAssertEqual(flowType, .myPageButtonTapped)
        XCTAssertTrue(self.navigation.isNaviRightButtonTapped)
    }
}
