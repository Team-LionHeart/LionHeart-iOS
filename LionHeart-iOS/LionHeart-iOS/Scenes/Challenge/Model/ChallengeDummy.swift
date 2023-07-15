//
//  ChallengeDummy.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/13.
//

import UIKit

struct ChallengeModel: AppData {
    let fetusName: String
    let challengeDay: Int
    let daddyLevel: Int
    let challengeDayList: [individualDayModel]
}

struct individualDayModel: AppData {
    let individualDay: String
}
