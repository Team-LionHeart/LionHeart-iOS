//
//  ArticleCategoryAdaptor.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/17.
//

import Foundation

final class ArticleCategoryAdaptor: ArticleCategoryNavigation, ArticleListByCategoryNavigation {
    
    let coordinator: ArticleCategoryCoordinator
    init(coordinator: ArticleCategoryCoordinator) {
        self.coordinator = coordinator
    }
    
    func articleListCellTapped(categoryName: String) {
        self.coordinator.showArticleListbyCategoryViewController(categoryName: categoryName)
    }
    
    func articleListByCategoryCellTapped(articleID: Int) {
        self.coordinator.showArticleDetailViewController(articleID: articleID)
    }
    
    func checkTokenIsExpired() {
        self.coordinator.exitApplication()
    }
    
    func navigationRightButtonTapped() {
        self.coordinator.showMypageViewController()
    }
    
    func navigationLeftButtonTapped() {
        self.coordinator.showBookmarkViewController()
    }
    
    func backButtonTapped() {
        self.coordinator.pop()
    }
}
