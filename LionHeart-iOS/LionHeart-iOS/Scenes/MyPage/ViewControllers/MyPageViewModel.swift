//
//  MyPageViewModel.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/20.
//

import Foundation
import Combine

protocol MyPageViewModelPresentable {}

protocol MyPageViewModel: ViewModel where Input == MyPageViewModelInput, Output == MyPageViewModelOutput {}

struct MyPageViewModelInput {
    let backButtonTapped: PassthroughSubject<Void, Never>
    let resignButtonTapped: PassthroughSubject<Void, Never>
    let viewWillAppearSubject: PassthroughSubject<Void, Never>
}

struct MyPageViewModelOutput {
    let viewWillAppearSubject: AnyPublisher<MyPageModel, Never>
}
