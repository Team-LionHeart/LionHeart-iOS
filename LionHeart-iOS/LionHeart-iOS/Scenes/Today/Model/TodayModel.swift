//
//  TodayModel.swift
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
}

extension TodayArticle {
    static var dummy: TodayArticle {
        return .init(fetalNickname: "김의성",
                     articleTitle: "안녕하세요\n김의성입니다",
                     articleDescription: "안녕세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하녕하세요안녕하세요안녕하세요안녕하세요안녕하세요",
                     currentWeek: 11, currentDay: 12, mainImageURL: "d")
    }
}
