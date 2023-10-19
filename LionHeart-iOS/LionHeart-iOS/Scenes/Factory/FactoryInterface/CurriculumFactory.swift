//
//  CurriculumFactory.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation


protocol CurriculumFactory {
    func makeAdaptor(coordinator: CurriculumCoordinator) -> EntireCurriculumNavigation
    func makeCurriculumViewController(coordinator: CurriculumCoordinator) -> CurriculumControllerable
    func makeCurriculumListViewController(coordinator: CurriculumCoordinator) -> CurriculumArticleByWeekControllerable
}
