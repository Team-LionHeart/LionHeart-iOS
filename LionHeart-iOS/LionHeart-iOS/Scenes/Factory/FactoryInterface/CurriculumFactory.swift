//
//  CurriculumFactory.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation


protocol CurriculumFactory {
    func makeCurriculumViewController() -> CurriculumControllerable
    func makeCurriculumListViewController() -> CurriculumArticleByWeekControllerable
}