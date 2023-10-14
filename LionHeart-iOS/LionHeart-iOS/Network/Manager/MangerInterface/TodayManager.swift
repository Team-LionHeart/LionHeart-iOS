//
//  TodayManager.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol TodayManager {
    func inquiryTodayArticle() async throws -> TodayArticle
}
