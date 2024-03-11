//
//  ArticleDetailViewModelTests.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 3/12/24.
//

import XCTest
import Combine
@testable import LionHeart_iOS

final class ArticleDetailViewModelTests: XCTestCase {
    
    var adaptor: ArticleAdaptorDummy!
    var manager: ArticleDetailManagerStub!
    var viewModel: ArticleDetailViewModelImpl!
    
    // Input Events
    private let viewWillAppear: PassthroughSubject<Void, Never> = .init()
    private let closeButtonTapped: PassthroughSubject<Void, Never> = .init()
    private let bookmarkButtonTapped: PassthroughSubject<Void, Never> = .init()
    private let scrollToTopButtonTapped: PassthroughSubject<Void, Never> = .init()
    
    private var input: ArticleDetailViewModelInput!
    private var subscriptions: Set<AnyCancellable>!

    override func setUp() {
        self.adaptor = ArticleAdaptorDummy()
        self.manager = ArticleDetailManagerStub()
        self.viewModel = .init(adaptor: self.adaptor, manager: self.manager)
        self.subscriptions = Set<AnyCancellable>()
        self.input = .init(
            viewWillAppear: self.viewWillAppear,
            closeButtonTapped: self.closeButtonTapped,
            bookmarkButtonTapped: self.bookmarkButtonTapped,
            scrollToTopButtonTapped: self.scrollToTopButtonTapped
        )
    }
    
    override func tearDown() {
        self.adaptor = nil
        self.manager = nil
        self.viewModel = nil
        self.input = nil
        self.subscriptions = nil
    }
    
    func test_북마크버튼_이벤트를_받으면_북마크저장API를_호출한다() {
        // Given
        let output = viewModel.transform(input: self.input)
        self.viewModel.articleId = 0
        self.viewModel.isBookMarked = true
        let expectation = XCTestExpectation(description: "")
        var result = ""
        output.bookmarkCompleted
            .sink { str in
                result = str
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        // When
        self.bookmarkButtonTapped.send()
        wait(for: [expectation], timeout: 2)
        
        // Then
        XCTAssertEqual(BookmarkCompleted.delete.message, result)
    }
    
    func test_viewWillAppear이벤트시_BlockTypeAppData의_배열의_데이터_output으로_나간다() {
        // Given
        let output = viewModel.transform(input: self.input)
        self.viewModel.articleId = 0
        let expect = XCTestExpectation(description: "")
        let expectation = Article(blockTypes: [
            .thumbnail(isMarked: true, model: .init(content: "string", caption: "string"))
        ], isMarked: true)
        
        var result: Article = .init(blockTypes: [], isMarked: true)
        output.articleDetail
            .sink { article in
                result = article
                expect.fulfill()
            }
            .store(in: &subscriptions)
        
        // When
        self.viewWillAppear.send()
        wait(for: [expect], timeout: 2)
        
        // Then
        XCTAssertEqual(result, expectation)
    }

    

}
