//
//  BookmarkAdaptor.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/17/23.
//

import Foundation

typealias EntireBookmarkNavigation = BookmarkNavigation

final class BookmarkAdaptor: EntireBookmarkNavigation {
    
    let coordinator: BookmarkCoordinator
    
    init(coordinator: BookmarkCoordinator) {
        self.coordinator = coordinator
    }
    
    func bookmarkCellTapped(articleID: Int) {
        coordinator.showArticleDetailViewController(articleId: articleID)
    }
    
    func checkTokenIsExpired() {
        coordinator.exitApplication()
    }
    
    func backButtonTapped() {
        coordinator.pop()
    }
}
