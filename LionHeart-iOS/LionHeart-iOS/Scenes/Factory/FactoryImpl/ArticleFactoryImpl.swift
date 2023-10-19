//
//  ArticleFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation

struct ArticleFactoryImpl: ArticleFactory {
    func makeArticleDetailViewController(adaptor: ArticleDetailModalNavigation) -> ArticleControllerable {
        let apiService = APIService()
        let bookmarkService = BookmarkServiceImpl(apiService: apiService)
        let articleService = ArticleServiceImpl(apiService: apiService)
        let manager = ArticleDetailManagerImpl(articleService: articleService,
                                                            bookmarkService: bookmarkService)
        let articleDetailViewController = ArticleDetailViewController(manager: manager, adaptor: adaptor)
        return articleDetailViewController
    }
}
