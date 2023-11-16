//
//  CompleteOnboardingViewModel.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/11/16.
//

import Foundation
import Combine

protocol CompleteOnboardingViewModelPresentable {
    func setUserData(_ userData: UserOnboardingModel)
}

protocol CompleteOnboardingViewModel: ViewModel where Input == CompleteOnboardingViewModelInput, Output == CompleteOnboardingViewModelOutput {}

struct CompleteOnboardingViewModelInput {
    let startButtonTapped: PassthroughSubject<Void, Never>
    let viewWillAppear: PassthroughSubject<Void, Never>
}

struct CompleteOnboardingViewModelOutput {
    let fetalNickname: AnyPublisher<String?, Never>
}
