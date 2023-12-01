//
//  TodayTest.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 11/30/23.
//

import XCTest
import UIKit
import Combine
@testable import LionHeart_iOS

final class TodayTest: XCTestCase {
    var adaptor: TodayNavigation!
    var manager: TodayManager!
    var jsonLoader: JSONLoader!
    var cancelBag: Set<AnyCancellable>!
    
    var viewWillAppearSubject: PassthroughSubject<Void, Never>!
    var navigationLeftButtonTapped: PassthroughSubject<Void, Never>!
    var navigationRightButtonTapped: PassthroughSubject<Void, Never>!
    var todayArticleTapped: PassthroughSubject<Void, Never>!
    
    override func setUp() {
        super.setUp()
        let navigationController = UINavigationController()
        let factory = TodayFactoryImpl()
        let coordinator = TodayCoordinatorImpl(navigationController: navigationController, factory: factory)
        adaptor = TodayAdaptor(coordinator: coordinator)
        jsonLoader = JSONLoader()
        cancelBag = Set()
        
        viewWillAppearSubject = PassthroughSubject()
        navigationLeftButtonTapped = PassthroughSubject()
        navigationRightButtonTapped = PassthroughSubject()
        todayArticleTapped = PassthroughSubject()
    }
    
    override func tearDown() {
        adaptor = nil
        manager = nil
        cancelBag = nil
        super.tearDown()
    }

    func test_투데이_아티클_조회_API() async throws {
        
        do {
            // Given
            let fileURL = jsonLoader.load(fileName: "TodayArticle")
            let data = try Data(contentsOf: fileURL)
            let urlSession = URLSessionStub(data: data)
            let apiService = APIService(session: urlSession)
            let articleService = ArticleServiceImpl(apiService: apiService)
            let manager = TodayManagerImpl(articleService: articleService)
            
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
    
//    func test_Transform_투데이_아티클_조회_API() throws {
//        // Given
//        let expectation = XCTestExpectation(description: "ViewModelTransformCheck")
//        
//        let fileURL = jsonLoader.load(fileName: "TodayArticle")
//        let data = try Data(contentsOf: fileURL)
//        
//        let decoder = JSONDecoder()
//        let decodedData = try decoder.decode(BaseResponse<TodayArticleResponse>.self, from: data)
//        
//        
//        
//        
//        let urlSession = URLSessionStub(data: data)
//        let apiService = APIService(session: urlSession)
//        let articleService = ArticleServiceImpl(apiService: apiService)
//        let manager = TodayManagerImpl(articleService: articleService)
//        let viewModel = TodayViewModelSpy(navigator: adaptor, manager: manager)
//        let todayViewController = TodayViewController(viewModel: viewModel)
//        
//    
////        let input = TodayViewModelInput(viewWillAppearSubject: todayViewController.viewWillAppearSubject,
////                                        navigationLeftButtonTapped: todayViewController.navigationLeftButtonTapped,
////                                        navigationRightButtonTapped: todayViewController.navigationRightButtonTapped,
////                                        todayArticleTapped: todayViewController.todayArticleTapped)
//        let viewWilAppearSubject = PassthroughSubject<Void, Never>()
//        let input = TodayViewModelInput(viewWillAppearSubject: viewWilAppearSubject, navigationLeftButtonTapped: <#T##PassthroughSubject<Void, Never>#>, navigationRightButtonTapped: <#T##PassthroughSubject<Void, Never>#>, todayArticleTapped: <#T##PassthroughSubject<Void, Never>#>)
//        
//        let output = viewModel.transform(input: input)
//        
//        var result: TodayArticle!
//        output.viewWillAppearSubject
//            .sink { article in
//                result = article
//                expectation.fulfill()
//            }
//            .store(in: &cancelBag)
//        
//        // When
////        todayViewController.viewWillAppearSubject
////            .send(())
//        viewWilAppearSubject.send(())
//        
//        wait(for: [expectation], timeout: 0.5)
//        
//        XCTAssertEqual(result, decodedData)
//        // Then
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
