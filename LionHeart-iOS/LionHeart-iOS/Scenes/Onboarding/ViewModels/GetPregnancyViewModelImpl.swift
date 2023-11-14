//
//  GetPregnancyViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/14.
//

import Foundation
import Combine

final class GetPregnancyViewModelImpl: GetPregnancyViewModel {
    
    
    func transform(input: GetPregnancyViewModelInput) -> GetPregnancyViewModelOutput {
        let pregancyTextfieldValidationMessage = input.pregancyTextfieldDidChanged
            .map { self.checkValidation(from: $0) }
            .eraseToAnyPublisher()
        return GetPregnancyViewModelOutput(pregancyTextfieldValidationMessage: pregancyTextfieldValidationMessage)
    }
    
    
    private func checkValidation(from text: String) -> (ValidationiMessage: String, isHidden: Bool) {
        var isHidden = false
        var ValidationiMessage = ""
        if text.count == 0 {
            ValidationiMessage = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldEmpty.errorMessage
            isHidden = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldEmpty.isHidden
        }
        if let textNumber = Int(text) {
            if textNumber == 0 {
                ValidationiMessage = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldOver.errorMessage
                isHidden = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldOver.isHidden
            } else if 4 <= textNumber && textNumber <= 40 {
                ValidationiMessage = ""
                isHidden = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldValid.isHidden
            } else {
                ValidationiMessage = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldOver.errorMessage
                isHidden = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldOver.isHidden
            }
        }
        return (ValidationiMessage: ValidationiMessage, isHidden: isHidden)
    }
}
