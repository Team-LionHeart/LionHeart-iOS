//
//  ArticleFactory.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation

protocol ArticleFactory {
    func makeArticleViewModel(coordinator: ArticleCoordinator) -> any ArticleDetailViewModel & ArticleDetailViewModelPresentable
    func makeAdaptor(coordinator: ArticleCoordinator) -> EntireArticleAdaptor
    func makeArticleDetailViewController(coordinator: ArticleCoordinator, articleId: Int) -> ArticleControllerable
}
