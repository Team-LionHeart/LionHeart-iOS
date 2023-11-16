//
//  OnboardingViewModel.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/15.
//

import Foundation
import Combine

protocol OnboardingViewModelPresentable {
    func setKakaoAccessToken(_ token: String?)
}

protocol OnboardingViewModel: ViewModel where Input == OnboardingViewModelInput, Output == OnboardingViewModelOutput {}

struct OnboardingViewModelInput {
    let pregenacy: CurrentValueSubject<(pregnancy: Int, isValid: Bool), Never>
    let fetalNickname: CurrentValueSubject<(fetalNickname: String, isValid: Bool), Never>
    let backButtonTapped: PassthroughSubject<Void, Never>
    let nextButtonTapped: PassthroughSubject<Void, Never>
}

struct OnboardingViewModelOutput {
    let pregenacyButtonState: AnyPublisher<Bool, Never>
    let fetalButtonState: AnyPublisher<Bool, Never>
    let onboardingFlow: AnyPublisher<OnbardingFlowType, Never>
    let signUpSubject: AnyPublisher<String, Never>
}
