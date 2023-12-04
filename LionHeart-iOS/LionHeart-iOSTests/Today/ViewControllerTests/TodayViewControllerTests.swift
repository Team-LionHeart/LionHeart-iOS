//
//  TodayViewControllerTests.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 12/3/23.
//

import XCTest
import Combine

@testable import LionHeart_iOS

final class TodayViewControllerTests: XCTestCase {
    
    var viewModel: TodayViewModelSpy!
    var cancelBag: Set<AnyCancellable>!

    override func setUp() {
        viewModel = TodayViewModelSpy()
        cancelBag = Set()
    }
    
    override func tearDown() {
        viewModel = nil
        cancelBag = nil
    }
    
    func test_viewModel_viewWillAppear_이벤트_전달_성공() {
        // Given
        let todayViewController = TodayViewController(viewModel: self.viewModel)
        let expectation = XCTestExpectation(description: "viewWillAppear가 불렸을 때")
        
        // When
        var isEventOccured: Bool!
        viewModel.isViewWillAppeared
            .sink { isTapped in
                isEventOccured = isTapped
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        todayViewController.viewWillAppear(false)
        
        // Then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertTrue(isEventOccured!)
    }
    
    func test_viewModel_네비바_왼쪽버튼_이벤트_전달_성공() {
        // Given
        let todayViewController = TodayViewController(viewModel: self.viewModel)
        let expectation = XCTestExpectation(description: "네비게이션바 왼쪽 버튼이 눌렸을 때")
        
        // When
        var isEventOccured: Bool!
        viewModel.isNaviLeftButtonTapped
            .sink { isTapped in
                isEventOccured = isTapped
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        todayViewController.loadViewIfNeeded()
        todayViewController.todayNavigationBar.rightFirstBarItem.sendActions(for: .touchUpInside)
        
        // Then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertTrue(isEventOccured!)
    }
    
    func test_viewModel_네비바_오른쪽버튼_이벤트_전달_성공() {
        // Given
        let todayViewController = TodayViewController(viewModel: self.viewModel)
        let expectation = XCTestExpectation(description: "네비게이션바 오른쪽 버튼이 눌렸을 때")
        
        // When
        var isEventOccured: Bool!
        viewModel.isNaviRightButtonTapped
            .sink { isTapped in
                isEventOccured = isTapped
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        todayViewController.loadViewIfNeeded()
        todayViewController.todayNavigationBar.rightSecondBarItem.sendActions(for: .touchUpInside)
        
        // Then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertTrue(isEventOccured!)
    }
    
    func test_viewModel_아티클탭_이벤트_전달_성공() {
        // Given
        let todayViewController = TodayViewController(viewModel: self.viewModel)
        let expectation = XCTestExpectation(description: "아티클화면 눌렀을 때")
        
        // When
        var isEventOccured: Bool!
        viewModel.isArticleTapped
            .sink { isTapped in
                isEventOccured = isTapped
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        todayViewController.loadViewIfNeeded()
        todayViewController.todayArticleTapped.send(())
        
        // Then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertTrue(isEventOccured!)
    }
    
    func test_Output_데이터바인딩_성공() {
        // Given
        let todayViewController = TodayViewController(viewModel: self.viewModel)
        
        // When
        let todayArticle = TodayArticle(fetalNickname: "김민재", articleTitle: "제목", articleDescription: "설명", currentWeek: 5, currentDay: 1, mainImageURL: "url", aticleID: 1)
        viewModel.todayArticle = todayArticle
        
        todayViewController.loadViewIfNeeded()
        let mainView = todayViewController.mainArticleView
        mainView.configureView(data: todayArticle)
        
        // Then
        XCTAssertEqual(mainView.weekInfomationLabel.text, todayArticle.currentWeek.description + "주 " + todayArticle.currentDay.description + "일차")
        XCTAssertEqual(mainView.articleTitleLabel.text, todayArticle.articleTitle)
        XCTAssertEqual(mainView.descriptionLabel.text, todayArticle.articleDescription)
    }
}
