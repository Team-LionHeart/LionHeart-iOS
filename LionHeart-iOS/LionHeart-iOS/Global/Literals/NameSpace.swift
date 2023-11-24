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

enum BookmarkCompleted {
    case save
    case delete
    case failure
    
    var message: String {
        switch self {
        case .save:
            return "북마크 저장에 성공했습니다."
        case .delete:
            return "북마크 삭제에 성공했습니다."
        case .failure:
            return "북마크 요청에 실패했습니다."
        }
    }
}
