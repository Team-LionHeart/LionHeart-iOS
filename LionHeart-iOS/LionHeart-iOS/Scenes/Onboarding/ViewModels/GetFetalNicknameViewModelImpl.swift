//
//  GetFetalNicknameViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/14/23.
//

import Foundation
import Combine

final class GetFetalNicknameViewModelImpl: GetFetalNicknameViewModel {
    func transform(input: GetFetalNicknameViewModelInput) -> GetFetalNicknameViewModelOutput {
        let pregancyTextfieldValidationMessage = input.fetalTextfieldDidChanged
            .map { text in
                var isHidden = false
                var validationMessage = ""
                if text.count == 0 {
                    validationMessage = OnboardingFetalNicknameTextFieldResultType.fetalNicknameTextFieldEmpty.errorMessage
                    isHidden = true
                } else if text.count <= 10 {
                    isHidden = false
                } else {
                    validationMessage = OnboardingFetalNicknameTextFieldResultType.fetalNicknameTextFieldOver.errorMessage
                    isHidden = true
                }
                return (fetalNickName: text, validationMessage: validationMessage, isHidden: isHidden)
            }
            .eraseToAnyPublisher()
        
        return GetFetalNicknameViewModelOutput(fetalTextfieldValidationMessage: pregancyTextfieldValidationMessage)
    }
}
