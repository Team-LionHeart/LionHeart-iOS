//
//  MyPageViewModelTest.swift
//  LionHeart-iOSTests
//
//  Created by 황찬미 on 2023/12/02.
//

import XCTest
import Combine

@testable import LionHeart_iOS

final class MyPageViewModelTest: MyPageViewModelTestSetUp {
    
    func test_MypageVM_viewWillAppear이후_AppData가_들어왔을때() {
        // given
        let expectation = XCTestExpectation(description: "app data가 성공적으로 들어왔을 때")
        self.manager.appData = .init(badgeImage: "LEVEL_ONE", nickname: "짠미", isAlarm: "On")
        
        // when
        var myPageModel: BadgeProfileAppData?
        output.viewWillAppearSubject
            .sink { value in
                myPageModel = value.profileData
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        viewWillAppearSubject.send(())
        
        // then
        let expectedValue = BadgeProfileAppData(badgeImage: "LEVEL_ONE", nickname: "짠미", isAlarm: "On")
        
        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(myPageModel, expectedValue)
    }
    
    func test_MyPageVM_viewWillAppear이후_에러발생했을때() {
        // given
        let expectation = XCTestExpectation(description: "error 발생했을 때")
        self.manager.appData = nil
        
        // when
        var myPageModel: BadgeProfileAppData?
        var willOccurError: NetworkError?
        
        output.viewWillAppearSubject
            .sink { value in
                myPageModel = value.profileData
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        self.viewModel.errorSubject
            .sink { error in
                willOccurError = error
            }
            .store(in: &cancelBag)
        
        viewWillAppearSubject.send(())
        
        // then
        let expectedValue = BadgeProfileAppData.empty
        let expectedError = NetworkError.badCasting
        
        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(myPageModel, expectedValue)
        XCTAssertEqual(willOccurError, expectedError)
    }
    
    func test_MyPageVM_resignButtonTapped이후_회원탈퇴성공하고_올바른값을전달하는지() {
        // given
//        let expectation = XCTestExpectation(description: "resignButtonTapped success")
        self.manager.resignResult = true
        
        // when
        var flowType: MyPageViewModelImpl.FlowType?
        self.viewModel.navigationSubject
            .sink { type in
                flowType = type
//                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        self.resignButtonTapped.send(())
        
        // then
        let expectedType = MyPageViewModelImpl.FlowType.resignButtonTapped
        
//        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(flowType, nil)

    }
    
    func test_MyPageVM_resignButtonTapped이후_에러발생했을때() {
        // given
//        let expectation = XCTestExpectation(description: "resinButtonTapped failure")
        self.manager.resignResult = nil
        
        // when
        var willOccurError: NetworkError?
        
        self.viewModel.errorSubject
            .sink { error in
                willOccurError = error
//                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        self.resignButtonTapped.send(())
        
        // then
        let expectedType = NetworkError.clientError(code: "V001", message: "탈퇴 실패")
        
//        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(willOccurError, nil)
    }
    
    func test_MyPageVM_backButtonTapped_올바른값전달하는지() {
        // given
        
        // when
        var flowType: MyPageViewModelImpl.FlowType?
        self.viewModel.navigationSubject
            .sink { type in
                flowType = type
            }
            .store(in: &cancelBag)
        
        self.backButtonTapped.send(())
        
        // then
        let expectedType = MyPageViewModelImpl.FlowType.backButtonTapped
        XCTAssertEqual(flowType, expectedType)
    }
}
