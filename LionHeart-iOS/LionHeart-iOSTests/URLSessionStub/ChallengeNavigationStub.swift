//
//  ChallengeNavigationStub.swift
//  LionHeart-iOSTests
//
//  Created by uiskim on 2023/12/01.
//

import Foundation
@testable import LionHeart_iOS

final class ChallengeNavigationStub: ChallengeNavigation {
    var leftButtonTapped = false
    var rightButtonTapped = false
    var appExit = false
    
    func navigationRightButtonTapped() {
        self.rightButtonTapped = true
    }
    
    func navigationLeftButtonTapped() {
        self.leftButtonTapped.toggle()
    }
    
    func checkTokenIsExpired() {
        self.appExit = true
    }
}
