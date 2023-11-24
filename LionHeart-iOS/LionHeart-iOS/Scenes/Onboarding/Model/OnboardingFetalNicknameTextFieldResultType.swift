//
//  OnboardingFetalNicknameTextFieldResultType.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import Foundation

enum OnboardingFetalNicknameTextFieldResultType {
    case fetalNicknameTextFieldEmpty
    case fetalNicknameTextFieldOver
    case fetalNicknameTextFieldValid

    var errorMessage: String {
        switch self {
        case .fetalNicknameTextFieldEmpty:
            return "입력된 내용이 없습니다."
        case .fetalNicknameTextFieldOver:
            return "10자 이내로 입력해주세요."
        case .fetalNicknameTextFieldValid:
            return "정상입니다"
        }
    }
    
    var isHidden: Bool {
        switch self {
        case .fetalNicknameTextFieldEmpty, .fetalNicknameTextFieldOver:
            return true
        case .fetalNicknameTextFieldValid:
            return false
        }
    }
}
