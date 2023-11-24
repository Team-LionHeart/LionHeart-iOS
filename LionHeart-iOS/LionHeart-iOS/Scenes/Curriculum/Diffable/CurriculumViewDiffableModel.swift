//
//  CurriculumViewDiffableModel.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/22/23.
//

import Foundation


enum CurriculumViewSection: CaseIterable {
    case month2
    case month3
    case month4
    case month5
    case month6
    case month7
    case month8
    case month9
    case month10
}

enum CurriculumViewItem: Hashable {
    case article(weekData: CurriculumDummyData)
}
