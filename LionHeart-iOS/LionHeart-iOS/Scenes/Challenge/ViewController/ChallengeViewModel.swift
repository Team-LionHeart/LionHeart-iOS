//
//  ChallengeViewModel.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/18.
//

import Foundation
import Combine

protocol ChallengeViewModelPresentable {}

protocol ChallengeViewModel: ViewModel where Input == ChallengeViewModelInput, Output == ChallengeViewModelOutput {}

struct ChallengeViewModelInput {
    let navigationLeftButtonTapped: PassthroughSubject<Void, Never>
    let navigationRightButtonTapped: PassthroughSubject<Void, Never>
    let viewWillAppearSubject: PassthroughSubject<Void, Never>
}

struct ChallengeViewModelOutput {
    let viewWillAppearSubject: AnyPublisher<Result<ChallengeData, NetworkError>, Never>
}
