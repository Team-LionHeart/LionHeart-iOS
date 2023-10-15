//
//  BookmarkFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

struct BookmarkFactoryImpl: BookmarkFactory {
    func makeBookmarkViewController() -> BookmarkViewControllerable {
        return BookmarkViewController(manager: BookmarkMangerImpl(bookmarkService: BookmarkServiceImpl(apiService: APIService())))
    }
}
