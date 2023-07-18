//
//  LoginRequest.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/17.
//

import Foundation

// 로그인 API에 필요한 body 구조체
// Data transfer Object (서버 <-> 클라)
struct LoginRequest: DTO, Request {
    let socialType: String
    let token: String
    let fcmToken: String
}
