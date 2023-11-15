//
//  GetFetalNicknameViewModel.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/14/23.
//

import Foundation
import Combine

protocol GetFetalNicknameViewModel: ViewModel where Input == GetFetalNicknameViewModelInput, Output == GetFetalNicknameViewModelOutput {}

struct GetFetalNicknameViewModelInput {
    let fetalTextfieldDidChanged: PassthroughSubject<String, Never>
}

struct GetFetalNicknameViewModelOutput {
    let fetalTextfieldValidationMessage: AnyPublisher<(fetalNickName: String, validationMessage: String, isHidden: Bool), Never>
}
