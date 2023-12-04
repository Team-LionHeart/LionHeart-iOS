//
//  MyPageViewControllerTest.swift
//  LionHeart-iOSTests
//
//  Created by 황찬미 on 2023/12/03.
//

import XCTest
import Combine

@testable import LionHeart_iOS

final class MyPageViewControllerTest: XCTestCase {
    
    var viewModel: MyPageViewModelSpy!
    var cancelBag: Set<AnyCancellable>!

    override func setUp() {
        viewModel = MyPageViewModelSpy()
        cancelBag = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        cancelBag = nil
    }
    
    func test_MyPageVM_viewWillAppear_이벤트전달성공했을때() {
        // given
        let expectation = XCTestExpectation(description: "view will appear")
        let viewController = MyPageViewController(viewModel: self.viewModel)
        
        // when
        var isEventOccured: Bool?
        self.viewModel.isViewWillAppearSubject
            .sink { event in
                isEventOccured = event
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        viewController.viewWillAppear(false)
        
        // then
        wait(for: [expectation], timeout: 0.3)
        XCTAssertTrue(isEventOccured!)
    }
    
    func test_MyPageVM_resignButtonTapped_이벤트전달성공했을때() {
        // given
        let expectation = XCTestExpectation(description: "resign button tapped")
        let viewController = MyPageViewController(viewModel: self.viewModel)
        
        // when
        var isEventOccured: Bool?
        self.viewModel.isResignButtonTapped
            .sink { event in
                isEventOccured = event
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        viewController.loadViewIfNeeded()
        viewController.resignButton.sendActions(for: .touchUpInside)
        
        // then
        wait(for: [expectation], timeout: 0.3)
        XCTAssertTrue(isEventOccured!)

    }
    
    func test_MyPageVM_backButtonTapped_이벤트전달성공했을때() {
        // given
        let expectation = XCTestExpectation(description: "back button tapped")
        let viewController = MyPageViewController(viewModel: self.viewModel)
        
        // when
        var isEventOccured: Bool?
        self.viewModel.isBackButtonTapped
            .sink { event in
                isEventOccured = event
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        viewController.loadViewIfNeeded()
        viewController.navigtaionBar.leftBarItem.sendActions(for: .touchUpInside)
        
        // then
        wait(for: [expectation], timeout: 0.3)
        XCTAssertTrue(isEventOccured!)
    }
    
    func test_MyPage데이터가_들어왔을때_UI에_잘반영되는지() {
        // given
        let viewController = MyPageViewController(viewModel: self.viewModel)
        let badgeData = BadgeProfileAppData(badgeImage: "LEVEL_ONE", nickname: "test nickname", isAlarm: "on")
        self.viewModel.myPageModel = MyPageModel(profileData: badgeData, appSettingData: [], customerServiceData: [])
        
        // when
        viewController.loadViewIfNeeded()
        let headerView = viewController.headerView
        viewController.setTableViewHeader(badgeData)
        
        // then
        XCTAssertEqual(headerView.badgeImageView.image, BadgeLevel(rawValue: "LEVEL_ONE")?.badgeImage)
        XCTAssertEqual(headerView.profileLabel.text, """
                                                     test nickname아빠님,
                                                     오늘도 멋진 아빠가 되어 볼까요?
                                                     """)
    }
}
