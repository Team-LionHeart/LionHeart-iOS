//
//  UserDefaultToken.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/17.
//

import Foundation

// UserDefault에 우리가 저장하는 구조체
struct UserDefaultToken: AppData, Codable {
    var refreshToken: String?
    var accessToken: String?
    var kakaoToken: String?
    let fcmToken: String?
    
    var isExistJWT: Bool {
        return !(self.refreshToken == nil)
    }
}

