//
//  SplashViewModel.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/16/23.
//

import Foundation
import Combine

protocol SplashViewModelPresentable {}

protocol SplashViewModel: ViewModel where Input == SplashViewModelInput, Output == SplashViewModelOutput {}

struct SplashViewModelInput {
    let lottiePlayFinished: PassthroughSubject<Void, Never>
}

struct SplashViewModelOutput {
    let splashNetworkErrorMessage: AnyPublisher<String, Never>
}
