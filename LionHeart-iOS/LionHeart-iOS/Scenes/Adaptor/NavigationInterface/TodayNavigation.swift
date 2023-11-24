//
//  TodayNavigation.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol TodayNavigation: ExpireNavigation, BarNavigation {
    func todayArticleTapped(articleID: Int)
}
