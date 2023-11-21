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
    let bookmarkButtonTapped: PassthroughSubject<(indexPath: IndexPath, isSelected: Bool), Never>
    let viewWillAppearSubject: PassthroughSubject<Void, Never>
    let backButtonTapped: PassthroughSubject<Void, Never>
}

struct CurriculumListWeekViewModelOutput {
    let articleByWeekData: AnyPublisher<(CurriculumWeekData, Bool, Bool), Never>
    let bookMarkCompleted: AnyPublisher<String, Never>
}
