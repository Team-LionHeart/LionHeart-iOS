//
//  OnboardingPageType.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//

import UIKit

enum OnboardingPageType: Int, CaseIterable {
    case getPregnancy
    case getFatalNickname
}

enum OnbardingFlowType: Int {
    case toGetPregnacny
    case toFatalNickname
    case toLogin
    case toCompleteOnboarding
}

extension OnboardingPageType {
    var viewController: UIViewController {
        switch self {
        case .getPregnancy:
            return GetPregnancyViewController()
        case .getFatalNickname:
            return GetFatalNicknameViewController()
        }
    }
    
    var progressValue: Float {
        switch self {
        case .getPregnancy:
            return 0.5
        case .getFatalNickname:
            return 1.0
        }
    }
    
    var forward: OnbardingFlowType {
        switch self {
        case .getPregnancy:
            return .toFatalNickname
        case .getFatalNickname:
            return .toCompleteOnboarding
        }
    }
    
    var back: OnbardingFlowType {
        switch self {
        case .getPregnancy:
            return .toLogin
        case .getFatalNickname:
            return .toGetPregnacny
        }
    }
}
