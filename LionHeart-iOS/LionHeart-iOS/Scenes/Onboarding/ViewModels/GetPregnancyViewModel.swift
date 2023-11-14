//
//  GetPregnancyViewModel.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/14.
//

import Foundation
import Combine

protocol GetPregnancyViewModel: ViewModel where Input == GetPregnancyViewModelInput, Output == GetPregnancyViewModelOutput {}

struct GetPregnancyViewModelInput {
    let pregancyTextfieldDidChanged: PassthroughSubject<String, Never>
}

struct GetPregnancyViewModelOutput {
    let pregancyTextfieldValidationMessage: AnyPublisher<(ValidationiMessage: String, PlaceHolder: String, isHidden: Bool), Never>
}

