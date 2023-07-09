//
//  NavigationBarType.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/10.
//

import Foundation

enum LHNavigationType {
    case today
    case explore
    case curriculumByWeek
    case challenge
    case onboarding
    case articleMain
    case bookmark
    case myPage
    case exploreEachCategory

    var title: String? {
        switch self {
        case .today: return "투데이"
        case .explore: return "탐색"
        case .challenge: return "챌린지"
        case .onboarding: return "회원가입"
        case .bookmark: return "북마크"
        case .myPage: return "프로필"
        case .exploreEachCategory, .curriculumByWeek, .articleMain: return nil
        }
    }

    var leftBarItemType: LeftBarItemType {
        switch self {
        case .today:
            return .buttonWithRightBarItems
        case .explore, .challenge:
            return .buttonWithRightBarItems
        case .articleMain: return .closeButtonWithTitle
        default: return .backButtonWithTitle
        }
    }
}


enum LeftBarItemType {
    case buttonWithRightBarItems
    case backButtonWithTitle
    case closeButtonWithTitle
}
