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
    let viewWillAppear: PassthroughSubject<Void, Never>
    let bookmarkButtonTapped: PassthroughSubject<Void, Never>
    let myPageButtonTapped: PassthroughSubject<Void, Never>
    let rightArrowButtonTapped: PassthroughSubject<IndexPath, Never>
}

struct CurriculumViewViewModelOutput {
    let curriculumMonth: AnyPublisher<(userInfo: UserInfoData, monthData: [CurriculumMonthData]), Never>
}
