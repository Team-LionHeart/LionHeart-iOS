//
//  BookmarkFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

struct BookmarkFactoryImpl: BookmarkFactory {
    func makeBookmarkViewController(adaptor: BookmarkAdaptor) -> BookmarkViewControllerable {
        let apiService = APIService()
        let bookmarkService = BookmarkServiceImpl(apiService: apiService)
        let manager = BookmarkMangerImpl(bookmarkService: bookmarkService)
        let bookmarkViewController = BookmarkViewController(manager: manager, navigator: adaptor)
        
        return bookmarkViewController
    }
}
