//
//  CurriculumListWeekViewModel.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/21/23.
//

import Foundation
import Combine

protocol CurriculumListWeekViewModelPresentable {
    func setWeek(week: Int)
}

protocol CurriculumListWeekViewModel: ViewModel where Input == CurriculumListWeekViewModelInput, Output == CurriculumListWeekViewModelOutput {}

struct CurriculumListWeekViewModelInput {
    let leftButtonTapped: PassthroughSubject<Void, Never>
    let rightButtonTapped: PassthroughSubject<Void, Never>
    let articleCellTapped: PassthroughSubject<IndexPath, Never>
    let bookmarkButtonTapped: PassthroughSubject<IndexPath, Never>
}

struct CurriculumListWeekViewModelOutput {
    let articleByWeekData: AnyPublisher<CurriculumWeekData, Never>
}
