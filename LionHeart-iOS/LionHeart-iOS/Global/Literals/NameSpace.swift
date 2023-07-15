//
//  NameSpace.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//

import Foundation

typealias Request = Encodable
typealias Response = Decodable

enum UserDefaultKey {
    static let token = "TOKEN"
}

enum SocialLoginType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
}
