//
//  BookmarkNavigation.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol BookmarkNavigation: ExpireNavigation, PopNavigation {
    func bookmarkCellTapped(articleID: Int)
}
