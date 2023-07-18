//
//  SignUpRequest.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/17.
//

import Foundation

struct SignUpRequest: DTO, Request {
    let socialType: String
    let token: String
    let fcmToken: String
    let pregnantWeeks: Int
    let babyNickname: String
}
