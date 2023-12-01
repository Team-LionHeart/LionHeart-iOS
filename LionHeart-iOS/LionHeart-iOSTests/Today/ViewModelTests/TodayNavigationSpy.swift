//
//  TodayNavigationMock.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 12/1/23.
//

import Foundation
import XCTest

@testable import LionHeart_iOS


final class TodayNavigationSpy: XCTestCase, TodayNavigation {
    
    var isTodayArticleTapped = false
    var isCheckedTokenIsExpired = false
    var isNaviRightButtonTapped = false
    var isNaviLeftButtonTapped = false
    
    var articleId: Int?
    
    func todayArticleTapped(articleID: Int) {
        self.articleId = articleID
        isTodayArticleTapped = true
    }
    
    func checkTokenIsExpired() {
        isCheckedTokenIsExpired = true
    }
    
    func navigationRightButtonTapped() {
        isNaviRightButtonTapped = true
    }
    
    func navigationLeftButtonTapped() {
        isNaviLeftButtonTapped = true
    }
}
