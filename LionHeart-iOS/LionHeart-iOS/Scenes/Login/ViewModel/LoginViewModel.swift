//
//  LoginViewModel.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/2/23.
//

import Foundation
import Combine

protocol LoginViewModelPresentable {}

protocol LoginViewModel: ViewModel where Input == LoginViewModelInput, Output == LoginViewModelOutput {}

struct LoginViewModelInput {
    let kakakoLoginButtonTap: PassthroughSubject<Void, Never>
}

struct LoginViewModelOutput {
    let loginSuccess: AnyPublisher<String, Never>
}
