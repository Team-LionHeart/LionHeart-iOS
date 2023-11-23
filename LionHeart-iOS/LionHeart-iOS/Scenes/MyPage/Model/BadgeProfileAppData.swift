//
//  BadgeProfileAppData.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/20.
//

import Foundation

struct BadgeProfileAppData: AppData, Hashable {
    let badgeImage: String
    let nickname: String
    let isAlarm: String
}

extension BadgeProfileAppData {
    static let empty: Self = .init(badgeImage: "", nickname: "", isAlarm: "")
}
