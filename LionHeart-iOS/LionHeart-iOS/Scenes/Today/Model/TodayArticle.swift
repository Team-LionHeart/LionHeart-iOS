//
//  TodayArticle.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/14.
//

import UIKit

struct TodayArticle: AppData {
    var fetalNickname: String
    var articleTitle: String
    var articleDescription: String
    var currentWeek: Int
    var currentDay: Int
    var mainImageURL: String
    var aticleID: Int
}

extension TodayArticle {
    static var emptyArticle = TodayArticle(fetalNickname: "", articleTitle: "", articleDescription: "", currentWeek: 0, currentDay: 0, mainImageURL: "", aticleID: 0)
}
