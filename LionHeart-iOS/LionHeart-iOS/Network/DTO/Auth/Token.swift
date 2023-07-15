//
//  Token.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/13.
//

import Foundation

/// Request와 Response의 data구조 모두 동일하기 때문에 Codable 채택
struct Token: Codable, DTO {
    let accessToken: String
    let refreshToken: String
}
