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
    case toCompleteOnboarding
}
