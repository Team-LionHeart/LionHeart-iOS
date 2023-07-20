//
//  ChallengeDataResponse.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/19.
//

import UIKit

struct ChallengeDataResponse: DTO, Response {
    let babyNickname: String
    let day: Int
    let level: String
    let attendances: [String]
}
