//
//  ChallengeViewControllerTests.swift
//  LionHeart-iOSTests
//
//  Created by uiskim on 2023/12/01.
//

import XCTest
import Combine
@testable import LionHeart_iOS

final class ChallengeViewControllerTests: XCTestCase {
    var viewModel: ChallengeViewModelStub!
    var cancelBag: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        self.viewModel = ChallengeViewModelStub()
        self.cancelBag = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.cancelBag = nil
    }
    
    func test_viewWillAppear의_시점이_viewModel에_잘_전달되었는지() {
        //given
        let inputData = ChallengeData(babyDaddyName: "튼튼이", howLongDay: 10, daddyLevel: "LEVEL_ONE", daddyAttendances: ["11/1", "11/2", "11/3"])
        self.viewModel.inputData = inputData
        let viewController = ChallengeViewController(viewModel: self.viewModel)
        
        //when
        viewController.loadViewIfNeeded()
        viewController.viewWillAppear(false)
        
        XCTAssertEqual(self.viewModel.willPublishedData, inputData)
    }

    func test_ChallengeVC의_UserData가_UI에_잘_반영되었는지() throws {
        //given
        let inputData = ChallengeData(babyDaddyName: "튼튼이", howLongDay: 10, daddyLevel: "LEVEL_ONE", daddyAttendances: ["11/1", "11/2", "11/3"])
        let viewController = ChallengeViewController(viewModel: self.viewModel)

        //when
        viewController.loadViewIfNeeded()
        viewController.configureData(inputData)
        
        //then
        XCTAssertEqual(viewController.nicknameLabel.text, "튼튼이아빠 님,")
        XCTAssertEqual(viewController.challengeDayLabel.text, "10일째 도전 중")
        XCTAssertEqual(viewController.challengelevelLabel.text, "사자력 Lv.1")
        
    }
    
    func test_ChallengeVC의_CollectionView에_데이터가_잘_반영되었는지() {
        //given
        let inputData = ChallengeData(babyDaddyName: "튼튼이", howLongDay: 10, daddyLevel: "LEVEL_ONE", daddyAttendances: ["11/1", "11/2", "11/3"])
        let viewController = ChallengeViewController(viewModel: self.viewModel)

        //when
        viewController.loadViewIfNeeded()
        viewController.configureData(inputData)

        //then
        let numberOfRows = viewController.challengeDayCheckCollectionView.numberOfItems(inSection: 0)
        XCTAssertEqual(numberOfRows, 20)
        
        let cell0 = viewController.challengeDayCheckCollectionView.dataSource?.collectionView(viewController.challengeDayCheckCollectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as! ChallengeDayCheckCollectionViewCollectionViewCell
        XCTAssertEqual(cell0.countLabel.text, inputData.daddyAttendances[0])
        XCTAssertEqual(cell0.backgroundColor, .designSystem(.background))
        XCTAssertEqual(cell0.countLabel.textColor, .designSystem(.white))
        
        let cell1 = viewController.challengeDayCheckCollectionView.dataSource?.collectionView(viewController.challengeDayCheckCollectionView, cellForItemAt: IndexPath(row: 1, section: 0)) as! ChallengeDayCheckCollectionViewCollectionViewCell
        XCTAssertEqual(cell1.countLabel.text, inputData.daddyAttendances[1])
        XCTAssertEqual(cell1.backgroundColor, .designSystem(.background))
        XCTAssertEqual(cell1.countLabel.textColor, .designSystem(.white))
        
        let cell2 = viewController.challengeDayCheckCollectionView.dataSource?.collectionView(viewController.challengeDayCheckCollectionView, cellForItemAt: IndexPath(row: 2, section: 0)) as! ChallengeDayCheckCollectionViewCollectionViewCell
        XCTAssertEqual(cell2.countLabel.text, inputData.daddyAttendances[2])
        XCTAssertEqual(cell2.backgroundColor, .designSystem(.background))
        XCTAssertEqual(cell2.countLabel.textColor, .designSystem(.white))
        
        let cell3 = viewController.challengeDayCheckCollectionView.dataSource?.collectionView(viewController.challengeDayCheckCollectionView, cellForItemAt: IndexPath(row: 3, section: 0)) as! ChallengeDayCheckCollectionViewCollectionViewCell
        XCTAssertEqual(cell3.countLabel.text, "\(0+3+1)")
        XCTAssertEqual(cell3.backgroundColor, .designSystem(.gray1000))
    }
    
    func test_Navigation의_북마크버튼이_잘_동작하는지() {
        //given
        let expectation = XCTestExpectation(description: "네비게이션왼쪽버튼이 눌렸을때")
        let viewController = ChallengeViewController(viewModel: self.viewModel)
        viewController.loadViewIfNeeded()
        
        //when
        var navigationType: ChallengeViewModelStub.FlowType?
        viewModel.navigationSubject
            .sink { type in
                navigationType = type
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        viewController.navigationBar.rightFirstBarItem.sendActions(for: .touchUpInside)
        
        //then
        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(navigationType, .bookmarkButtonTapped)
    }
    
    func test_Navigation의_마이페이지버튼이_잘_동작하는지() {
        //given
        let expectation = XCTestExpectation(description: "네비게이션오른쪽버튼이 눌렸을때")
        let viewController = ChallengeViewController(viewModel: self.viewModel)
        viewController.loadViewIfNeeded()
        
        //when
        var navigationType: ChallengeViewModelStub.FlowType?
        viewModel.navigationSubject
            .sink { type in
                navigationType = type
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        viewController.navigationBar.rightSecondBarItem.sendActions(for: .touchUpInside)
        
        //then
        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(navigationType, .myPageButtonTapped)
    }
}
