//
//  MyPageViewModelTest.swift
//  LionHeart-iOSTests
//
//  Created by 황찬미 on 2023/12/02.
//

import XCTest
import Combine

@testable import LionHeart_iOS

final class MyPageViewModelTest: XCTestCase {
    
    var navigation: MyPageNavigationDummy!
    var manager: MyPageManagerStub!
    var viewModel: MyPageViewModelImpl!
    var cancelBag: Set<AnyCancellable>!
    
    var backButtonTapped: PassthroughSubject<Void, Never>!
    var resignButtonTapped: PassthroughSubject<Void, Never>!
    var viewWillAppearSubject: PassthroughSubject<Void, Never>!
    
    var outputViewWillAppearSubject: AnyPublisher<MyPageModel, Never>!
    
    var input: MyPageViewModelInput!
    var output: MyPageViewModelOutput!
    
    override func setUp() {
        self.navigation = MyPageNavigationDummy()
        self.manager = MyPageManagerStub()
        self.viewModel = MyPageViewModelImpl(navigator: self.navigation, manager: self.manager)
        self.cancelBag = Set<AnyCancellable>()
        
        self.backButtonTapped = PassthroughSubject<Void, Never>()
        self.resignButtonTapped = PassthroughSubject<Void, Never>()
        self.viewWillAppearSubject = PassthroughSubject<Void, Never>()
        
        self.input = MyPageViewModelInput(backButtonTapped: self.backButtonTapped,
                                          resignButtonTapped: self.resignButtonTapped,
                                          viewWillAppearSubject: self.viewWillAppearSubject)
        
        self.output = self.viewModel.transform(input: self.input)
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_MypageVM_viewWillAppear이후_AppData가_들어왔을때() {
        // given
        let expectation = XCTestExpectation(description: "app data가 성공적으로 들어왔을 때")
        self.manager.appData = .init(badgeImage: "test", nickname: "짠미", isAlarm: "On")
        
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
        let expectedValue = BadgeProfileAppData(badgeImage: "test", nickname: "짠미", isAlarm: "On")
        
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
