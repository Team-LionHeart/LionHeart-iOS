//
//  TodayViewModelSetUp.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 12/1/23.
//

import XCTest
import Combine

@testable import LionHeart_iOS

class TodayViewModelSetUp: XCTestCase {
    
    var viewWillAppearSubject: PassthroughSubject<Void, Never>!
    var navigationLeftButtonTapped: PassthroughSubject<Void, Never>!
    var navigationRightButtonTapped: PassthroughSubject<Void, Never>!
    var todayArticleTapped: PassthroughSubject<Void, Never>!
    
    var input: TodayViewModelInput!
    var output: TodayViewModelOutput!

    var manager: TodayManagerStub!
    var navigation: TodayNavigationSpy!
    var viewModel: TodayViewModelImpl!
    var cancelBag: Set<AnyCancellable>!
    
    override func setUp() {
        self.manager = TodayManagerStub()
        self.navigation = TodayNavigationSpy()
        self.viewModel = TodayViewModelImpl(navigator: self.navigation, manager: self.manager)

        self.viewWillAppearSubject = PassthroughSubject()
        self.navigationLeftButtonTapped = PassthroughSubject()
        self.navigationRightButtonTapped = PassthroughSubject()
        self.todayArticleTapped = PassthroughSubject()
        
        self.input = TodayViewModelInput(viewWillAppearSubject: viewWillAppearSubject,
                                         navigationLeftButtonTapped: navigationLeftButtonTapped,
                                         navigationRightButtonTapped: navigationRightButtonTapped,
                                         todayArticleTapped: todayArticleTapped)

        self.output = viewModel.transform(input: self.input)
        self.cancelBag = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        self.navigationLeftButtonTapped = nil
        self.navigationRightButtonTapped = nil
        self.viewWillAppearSubject = nil
        self.input = nil
        self.output = nil
        self.manager = nil
        self.navigation = nil
        self.viewModel = nil
    }
}

    
