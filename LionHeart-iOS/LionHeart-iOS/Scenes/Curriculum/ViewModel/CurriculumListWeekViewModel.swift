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
    let leftButtonTapped: PassthroughSubject<CurriculumListWeekButtonType, Never>
    let rightButtonTapped: PassthroughSubject<CurriculumListWeekButtonType, Never>
    let articleCellTapped: PassthroughSubject<IndexPath, Never>
    let bookmarkButtonTapped: PassthroughSubject<(indexPath: IndexPath, isSelected: Bool), Never>
    let viewWillAppearSubject: PassthroughSubject<CurriculumListWeekButtonType, Never>
    let backButtonTapped: PassthroughSubject<Void, Never>
}

struct CurriculumListWeekViewModelOutput {
    let articleByWeekData: AnyPublisher<(data: CurriculumWeekData, leftButtonHidden: Bool, rightButtonHidden: Bool), Never>
    let bookMarkCompleted: AnyPublisher<String, Never>
}

enum CurriculumListWeekButtonType {
    case left
    case right
    case none
    
    var addValue: Int {
        switch self {
        case .left:
            return -1
        case .right:
            return 1
        case .none:
            return 0
        }
    }
}
