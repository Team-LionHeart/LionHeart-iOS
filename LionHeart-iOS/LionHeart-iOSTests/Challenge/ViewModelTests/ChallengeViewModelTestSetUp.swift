//
//  ChallengeViewModelTestSetUp.swift
//  LionHeart-iOSTests
//
//  Created by uiskim on 2023/12/01.
//

import XCTest
import Combine

@testable import LionHeart_iOS

class ChallengeViewModelTestSetUp: XCTestCase {

    var navigationLeftButtonTapped: PassthroughSubject<Void, Never>!
    var navigationRightButtonTapped: PassthroughSubject<Void, Never>!
    var viewWillAppearSubject: PassthroughSubject<Void, Never>!
    
    var input: ChallengeViewModelInput!
    var output: ChallengeViewModelOutput!
    
    var manager: ChallengeManagerStub!
    var navigation: ChallengeNavigationStub!
    var viewModel: ChallengeViewModelImpl!
    var cancelBag: Set<AnyCancellable>!

    override func setUp() {
        self.manager = ChallengeManagerStub()
        self.navigation = ChallengeNavigationStub()
        self.viewModel = ChallengeViewModelImpl(navigator: self.navigation, manager: self.manager)
        
        self.navigationLeftButtonTapped = PassthroughSubject<Void, Never>()
        self.navigationRightButtonTapped = PassthroughSubject<Void, Never>()
        self.viewWillAppearSubject = PassthroughSubject<Void, Never>()
        
        self.input = .init(navigationLeftButtonTapped: self.navigationLeftButtonTapped, navigationRightButtonTapped: self.navigationRightButtonTapped, viewWillAppearSubject: self.viewWillAppearSubject)
    
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
