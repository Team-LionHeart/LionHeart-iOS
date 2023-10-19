//
//  ArticleAdaptor.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/19.
//

import Foundation

final class ArticleAdaptor: ArticleDetailModalNavigation {
    
    private let coordinator: ArticleCoordinator
    
    init(coordinator: ArticleCoordinator) {
        self.coordinator = coordinator
    }
    
    func checkTokenIsExpired() {
        coordinator.exitApplication()
    }
    
    func closeButtonTapped() {
        coordinator.dimiss()
    }
}
