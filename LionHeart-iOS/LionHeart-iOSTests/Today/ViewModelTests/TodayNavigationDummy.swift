//
//  TodayNavigationMock.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 12/1/23.
//

import Foundation

@testable import LionHeart_iOS


final class TodayNavigationDummy: TodayNavigation {
    func todayArticleTapped(articleID: Int) {
        print("아티클 탭 tapped")
    }
    
    func checkTokenIsExpired() {
        print("토큰 만료")
    }
    
    func navigationRightButtonTapped() {
        print("마이페이지 버튼 탭 Tapped")
    }
    
    func navigationLeftButtonTapped() {
        print("북마크 탭 Tapped")
    }
}
