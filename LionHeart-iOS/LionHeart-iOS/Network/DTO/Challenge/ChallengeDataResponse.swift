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

extension ChallengeDataResponse {
    func toAppData() -> ChallengeData {
        return .init(babyDaddyName: self.babyNickname, howLongDay: self.day, daddyLevel: self.level, daddyAttendances: self.attendances)
    }
}
