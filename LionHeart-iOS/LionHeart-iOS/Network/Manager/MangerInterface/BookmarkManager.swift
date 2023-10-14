//
//  BookmarkManager.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol BookmarkManager {
    func getBookmark() async throws -> BookmarkAppData
    func postBookmark(model: BookmarkRequest) async throws
}
