//
//  BookmarkFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

struct BookmarkFactoryImpl: BookmarkFactory {
    func makeAdaptor(coordinator: BookmarkCoordinator) -> EntireBookmarkNavigation {
        let adaptor = BookmarkAdaptor(coordinator: coordinator)
        return adaptor
    }
    
    func makeBookmarkViewController(coordinator: BookmarkCoordinator) -> BookmarkViewControllerable {
        let adaptor = self.makeAdaptor(coordinator: coordinator)
        let apiService = APIService()
        let bookmarkService = BookmarkServiceImpl(apiService: apiService)
        let manager = BookmarkMangerImpl(bookmarkService: bookmarkService)
        let bookmarkViewController = BookmarkViewController(manager: manager, navigator: adaptor)
        
        return bookmarkViewController
    }
}
