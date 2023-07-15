//
//  OnboardingPageType.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//

import UIKit

enum OnboardingPageType: Int, CaseIterable {
    case getPregnancy = 0
    case getFetalNickname = 1
}

enum OnbardingFlowType: Int {
    case toGetPregnacny
    case toFetalNickname
    case toLogin
    case toCompleteOnboarding
}

extension OnboardingPageType {
    
    var progressValue: Float {
        switch self {
        case .getPregnancy:
            return .half
        case .getFetalNickname:
            return .full
        }
    }
    
    var forward: OnbardingFlowType {
        switch self {
        case .getPregnancy:
            return .toFetalNickname
        case .getFetalNickname:
            return .toCompleteOnboarding
        }
    }
    
    var back: OnbardingFlowType {
        switch self {
        case .getPregnancy:
            return .toLogin
        case .getFetalNickname:
            return .toGetPregnacny
        }
    }
}
