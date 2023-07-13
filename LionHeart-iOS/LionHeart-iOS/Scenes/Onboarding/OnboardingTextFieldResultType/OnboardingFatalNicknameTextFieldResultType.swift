//
//  OnboardingFatalNicknameTextFieldResultType.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import Foundation

enum OnboardingFatalNicknameTextFieldResultType {
    case fatalNicknameTextFieldEmpty
    case fatalNicknameTextFieldOver
    case fatalNicknameTextFieldValid

    var errorMessage: String {
        switch self {
        case .fatalNicknameTextFieldEmpty:
            return "입력된 내용이 없습니다."
        case .fatalNicknameTextFieldOver:
            return "10자 이내로 입력해주세요."
        case .fatalNicknameTextFieldValid:
            return "정상입니다"
        }
    }
    
    var isHidden: Bool {
        switch self {
        case .fatalNicknameTextFieldEmpty, .fatalNicknameTextFieldOver:
            return true
        case .fatalNicknameTextFieldValid:
            return false
        }
    }
}
