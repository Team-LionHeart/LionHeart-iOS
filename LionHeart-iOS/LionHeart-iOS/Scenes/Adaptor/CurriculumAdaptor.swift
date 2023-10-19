//
//  CurriculumAdaptor.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/17/23.
//

import Foundation

typealias EntireCurriculumNavigation = CurriculumNavigation & CurriculumListByWeekNavigation


final class CurriculumAdaptor: EntireCurriculumNavigation {

    let coordinator: CurriculumCoordinator
    
    init(coordinator: CurriculumCoordinator) {
        self.coordinator = coordinator
    }
    
    func articleListCellTapped(itemIndex: Int) {
        self.coordinator.showCurriculumListViewController(itemIndex: itemIndex)
    }
    
    func navigationRightButtonTapped() {
        self.coordinator.showMypageViewController()
    }
    
    func navigationLeftButtonTapped() {
        self.coordinator.showBookmarkViewController()
    }
    
    func checkTokenIsExpired() {
        self.coordinator.exitApplication()
    }
    
    func curriculumArticleListCellTapped(articleId: Int) {
        self.coordinator.showArticleDetailViewController(articleId: articleId)
    }
    
    func backButtonTapped() {
        self.coordinator.pop()
    }
    
}
