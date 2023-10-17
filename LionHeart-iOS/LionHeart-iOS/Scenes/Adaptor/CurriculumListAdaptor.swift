//
//  CurriculumListAdaptor.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/17/23.
//

import Foundation


final class CurriculumListAdaptor: CurriculumListByWeekNavigation {
    
    let coordinator: CurriculumListCoordinator
    
    init(coordinator: CurriculumListCoordinator) {
        self.coordinator = coordinator
    }
    
    func curriculumArticleListCellTapped(articleId: Int) {
        self.coordinator.showArticleDetailViewController(articleId: articleId)
    }
    
    func backButtonTapped() {
        self.coordinator.popDismiss()
    }
    
    func checkTokenIsExpired() {
        self.coordinator.exitApplication()
    }
}
