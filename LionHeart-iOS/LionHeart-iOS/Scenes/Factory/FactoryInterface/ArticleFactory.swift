//
//  ArticleFactory.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation

protocol ArticleFactory {
    func makeAdaptor(coordinator: ArticleCoordinator) -> EntireArticleAdaptor
    func makeArticleDetailViewController(coordinator: ArticleCoordinator) -> ArticleControllerable
}
