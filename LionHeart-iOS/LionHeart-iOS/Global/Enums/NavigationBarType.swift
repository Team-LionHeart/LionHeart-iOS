//
//  NavigationBarType.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/10.
//

import UIKit

enum LHNavigationType {
    case today
    case explore
    case curriculumMain
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
        case .curriculumMain: return "커리큘럼"
        }
    }

    var leftBarItemType: LeftBarItemType {
        switch self {
        case .explore, .challenge, .curriculumMain, .today:
            return .buttonWithRightBarItems
        case .articleMain: return .closeButtonWithTitle
        default: return .backButtonWithTitle
        }
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .today:
            return .designSystem(.black)
        case .explore, .curriculumMain, .curriculumByWeek, .challenge, .onboarding, .articleMain, .bookmark, .myPage, .exploreEachCategory:
            return .designSystem(.background)
        }
    }
}


enum LeftBarItemType {
    case buttonWithRightBarItems
    case backButtonWithTitle
    case closeButtonWithTitle
}
