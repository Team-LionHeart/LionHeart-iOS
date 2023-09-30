//
//  Badge.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import UIKit

enum BadgeLevel: String {
    case level01 = "LEVEL_ONE"
    case level02 = "LEVEL_TWO"
    case level03 = "LEVEL_THREE"
    case level04 = "LEVEL_FOUR"
    case level05 = "LEVEL_FIVE"
    
    var badgeLevel: Int {
        switch self {
        case .level01: return 1
        case .level02: return 2
        case .level03: return 3
        case .level04: return 4
        case .level05: return 5
        }
    }
    
    var badgeImage: UIImage {
        switch self {
        case .level01: return ImageLiterals.ChallengeBadge.level01
        case .level02: return ImageLiterals.ChallengeBadge.level02
        case .level03: return ImageLiterals.ChallengeBadge.level03
        case .level04: return ImageLiterals.ChallengeBadge.level04
        case .level05: return ImageLiterals.ChallengeBadge.level05
        }
    }
    
    var progreddbarLottie: String {
        switch self {
        case .level01: return "Level1"
        case .level02: return "Level2"
        case .level03: return "Level3"
        case .level04: return "Level4"
        case .level05: return "Level5"
        }
    }
}
