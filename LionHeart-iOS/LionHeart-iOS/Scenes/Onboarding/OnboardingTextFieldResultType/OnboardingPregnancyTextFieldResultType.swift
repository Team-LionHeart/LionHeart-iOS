//
//  OnboardingPregnancyTextFieldResultType.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import Foundation

enum OnboardingPregnancyTextFieldResultType {
    case pregnancyTextFieldEmpty
    case pregnancyTextFieldValid
    case pregnancyTextFieldOver
    
    var errorMessage: String {
        switch self {
        case .pregnancyTextFieldEmpty:
            return "입력된 내용이 없습니다"
        case .pregnancyTextFieldValid:
            return "정상입니다"
        case .pregnancyTextFieldOver:
            return "1에서 40 사이의 숫자를 입력해주세요."
        }
    }
    
    var isHidden: Bool {
        switch self {
        case .pregnancyTextFieldEmpty, .pregnancyTextFieldOver:
            return true
        case .pregnancyTextFieldValid:
            return false
        }
    }
}
