//
//  CurriculumListManager.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol CurriculumListManager {
    func postBookmark(model: BookmarkRequest) async throws
    func getArticleListByWeekInfo(week: Int) async throws -> CurriculumWeekData
}
