//
//  MyPageModel.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/20.
//

import Foundation

struct MyPageModel: Equatable {
    let profileData: BadgeProfileAppData
    let appSettingData: [MyPageRow]
    let customerServiceData: [MyPageRow]
}

extension MyPageModel {
    static var empty: Self {
        return .init(profileData: .empty, appSettingData: [], customerServiceData: [])
    }
}
