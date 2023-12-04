//
//  MyPageNavigationDummy.swift
//  LionHeart-iOSTests
//
//  Created by 황찬미 on 2023/12/03.
//

import UIKit

@testable import LionHeart_iOS

final class MyPageNavigationDummy: MyPageNavigation {
    func checkTokenIsExpired() {
        print("회원 탈퇴")
    }
    
    func backButtonTapped() {
        print("뒤로가기 버튼 클릭")
    }
}
