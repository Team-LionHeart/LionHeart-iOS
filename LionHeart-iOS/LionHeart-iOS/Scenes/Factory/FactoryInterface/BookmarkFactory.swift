//
//  BookmarkFactory.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

protocol BookmarkFactory {
    func makeBookmarkViewController(adaptor: BookmarkAdaptor) -> BookmarkViewControllerable
}
