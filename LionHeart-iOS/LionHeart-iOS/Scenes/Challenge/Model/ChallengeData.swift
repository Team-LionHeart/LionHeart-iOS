//
//  ChallengeData.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/13.
//

import UIKit

struct ChallengeData: AppData {
    let babyDaddyName: String
    let howLongDay: Int
    let daddyLevel: String
    let daddyAttendances: [String]
}

extension ChallengeData {
    static var empty: Self {
        return .init(babyDaddyName: "", howLongDay: 0, daddyLevel: "", daddyAttendances: [])
    }
}
