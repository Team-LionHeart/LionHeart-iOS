//
//  TodayManagerStub.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 12/1/23.
//

import Foundation

@testable import LionHeart_iOS

final class TodayManagerStub: TodayManager {
    
    var todayArticle: TodayArticle?
    
    func inquiryTodayArticle() throws -> LionHeart_iOS.TodayArticle {
        guard let todayArticle else { return TodayArticle.emptyArticle }
        return todayArticle
    }
}
