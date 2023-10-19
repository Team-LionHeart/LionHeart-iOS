//
//  ArticleAdaptor.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/19.
//

import Foundation

typealias EntireArticleAdaptor = ArticleDetailModalNavigation

final class ArticleAdaptor: EntireArticleAdaptor {
    
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
