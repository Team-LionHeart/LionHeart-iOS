//
//  MyPageResponse.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/21.
//

import Foundation

struct MyPageResponse: DTO, Response, Equatable {
    let babyNickname: String
    let level: String
    let notificationStatus: String
}
