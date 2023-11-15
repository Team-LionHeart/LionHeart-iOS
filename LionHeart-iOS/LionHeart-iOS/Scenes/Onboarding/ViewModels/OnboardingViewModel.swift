//
//  OnboardingViewModel.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/15.
//

import Foundation
import Combine

protocol OnboardingViewModel: ViewModel where Input == OnboardingViewModelInput, Output == OnboardingViewModelOutput {}

struct OnboardingViewModelInput {
    //임신주차를 받는다
    let pregenacy: CurrentValueSubject<(pregnancy: Int, isValid: Bool), Never>
    //태명을 받는다
    let fetalNickname: CurrentValueSubject<(fetalNickname: String, isValid: Bool), Never>
    //백버튼을 누른다
    let backButtonTapped: PassthroughSubject<Void, Never>
    //다음버튼을 누른다
    let nextButtonTapped: PassthroughSubject<Void, Never>
}

struct OnboardingViewModelOutput {
    // 버튼상태
    let pregenacyButtonState: AnyPublisher<Bool, Never>
    let fetalButtonState: AnyPublisher<Bool, Never>
    let onboardingFlow: AnyPublisher<(oldValue: OnbardingFlowType, newValue: OnbardingFlowType), Never>
    let signUpSubject: AnyPublisher<String, Never>
}
