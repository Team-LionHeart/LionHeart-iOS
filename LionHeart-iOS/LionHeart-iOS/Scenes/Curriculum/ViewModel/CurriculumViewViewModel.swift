//
//  CurriculumViewViewModel.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/22/23.
//

import Foundation
import Combine

protocol CurriculumViewViewModelPresentable {}

protocol CurriculumViewViewModel: ViewModel where Input == CurriculumViewViewModelInput, Output == CurriculumViewViewModelOutput {}

struct CurriculumViewViewModelInput {
    let viewDidLayoutSubviews: PassthroughSubject<Void, Never>
    let viewWillAppear: PassthroughSubject<Void, Never>
    let bookmarkButtonTapped: PassthroughSubject<Void, Never>
    let myPageButtonTapped: PassthroughSubject<Void, Never>
    let rightArrowButtonTapped: PassthroughSubject<Int, Never>
    let toggleButtonTapped: PassthroughSubject<IndexPath, Never>
}

struct CurriculumViewViewModelOutput {
    let firstScrollIndexPath: AnyPublisher<IndexPath, Never>
    let curriculumMonth: AnyPublisher<(userInfo: UserInfoData, monthData: [CurriculumMonthData]), Never>
    let toggleButtonTapped: AnyPublisher<[CurriculumMonthData], Never>
//    let userInfo: AnyPublisher<UserInfoData, Never>
}
