//
//  MyPageViewModelTestSetUp.swift
//  LionHeart-iOSTests
//
//  Created by 황찬미 on 2023/12/03.
//

import XCTest
import Combine

@testable import LionHeart_iOS

class MyPageViewModelTestSetUp: XCTestCase {

    var navigation: MyPageNavigationDummy!
    var manager: MyPageManagerStub!
    var viewModel: MyPageViewModelImpl!
    var cancelBag: Set<AnyCancellable>!
    
    var backButtonTapped: PassthroughSubject<Void, Never>!
    var resignButtonTapped: PassthroughSubject<Void, Never>!
    var viewWillAppearSubject: PassthroughSubject<Void, Never>!
    
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
        self.navigation = nil
        self.manager = nil
        self.viewModel = nil
        self.cancelBag = nil
        
        self.backButtonTapped = nil
        self.resignButtonTapped = nil
        self.viewWillAppearSubject = nil
        
        self.input = nil
        self.output = nil
    }

}
