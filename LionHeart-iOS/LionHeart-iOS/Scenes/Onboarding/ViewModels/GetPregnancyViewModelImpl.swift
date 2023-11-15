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
            .compactMap { self.checkValidation(from: $0) }
            .eraseToAnyPublisher()
        return GetPregnancyViewModelOutput(pregancyTextfieldValidationMessage: pregancyTextfieldValidationMessage)
    }
    
    
    private func checkValidation(from text: String) -> (pregnancy: Int, validationMessage: String, isHidden: Bool)? {
        var isHidden = false
        var validationMessage = ""
        if text.count == 0 {
            validationMessage = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldEmpty.errorMessage
            isHidden = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldEmpty.isHidden
        }
        guard let textNumber = Int(text) else { return nil }
        if textNumber == 0 {
            validationMessage = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldOver.errorMessage
            isHidden = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldOver.isHidden
        } else if 4 <= textNumber && textNumber <= 40 {
            validationMessage = ""
            isHidden = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldValid.isHidden
        } else {
            validationMessage = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldOver.errorMessage
            isHidden = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldOver.isHidden
        }
        
        return (pregnancy: textNumber, validationMessage: validationMessage, isHidden: isHidden)
    }
}
