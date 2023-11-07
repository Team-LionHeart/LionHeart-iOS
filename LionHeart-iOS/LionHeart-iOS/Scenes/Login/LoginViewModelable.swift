//
//  LoginViewModelable.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/4/23.
//

import Foundation
import Combine

protocol LoginViewModel: ViewModel where Input == LoginViewModelInput, Output == LoginViewModelOutput {}

struct LoginViewModelInput {
    let kakakoLoginButtonTap: PassthroughSubject<Void, Never>
}

struct LoginViewModelOutput {
    let loginSuccess: AnyPublisher<Future<String, NetworkError>, Never>
    let errorStream: PassthroughSubject<String, Never>
}
