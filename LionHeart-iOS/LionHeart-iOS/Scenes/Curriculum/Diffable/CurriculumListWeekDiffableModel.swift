//
//  CurriculumListWeekDiffableModel.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/21/23.
//

import Foundation


enum CurriculumListWeekSection {
    case articleListByWeek
}

enum CurriculumListWeekItem: Hashable {
    case article(weekData: ArticleDataByWeek)
}
