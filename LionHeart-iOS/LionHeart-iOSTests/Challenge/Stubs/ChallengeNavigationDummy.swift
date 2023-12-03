//
//  ChallengeNavigationStub.swift
//  LionHeart-iOSTests
//
//  Created by uiskim on 2023/12/01.
//

import Foundation
@testable import LionHeart_iOS

final class ChallengeNavigationDummy: ChallengeNavigation {
    
    func navigationRightButtonTapped() {
        print("왼쪽버튼눌림")
    }
    
    func navigationLeftButtonTapped() {
        print("오른쪽버튼눌림")
    }
    
    func checkTokenIsExpired() {
        print("앱강제종료")
    }
}
