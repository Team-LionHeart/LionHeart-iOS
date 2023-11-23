//
//  TodayViewModel.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/19.
//

import Foundation
import Combine

protocol TodayViewModelPresentable {}

protocol TodayViewModel: ViewModel where Input == TodayViewModelInput, Output == TodayViewModelOutput {}

struct TodayViewModelInput {
    let viewWillAppearSubject: PassthroughSubject<Void, Never>
    let navigationLeftButtonTapped: PassthroughSubject<Void, Never>
    let navigationRightButtonTapped: PassthroughSubject<Void, Never>
    let todayArticleTapped: PassthroughSubject<Void, Never>
}

struct TodayViewModelOutput {
    let viewWillAppearSubject: AnyPublisher<TodayArticle, Never>
}
