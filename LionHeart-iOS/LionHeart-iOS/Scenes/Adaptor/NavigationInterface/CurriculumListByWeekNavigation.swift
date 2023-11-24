//
//  CurriculumListByWeekNavigation.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol CurriculumListByWeekNavigation: ExpireNavigation, PopNavigation {
    func curriculumArticleListCellTapped(articleId: Int)
}
