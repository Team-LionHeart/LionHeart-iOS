//
//  TodayArticleResponse.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/18.
//

import UIKit

struct TodayArticleResponse: DTO, Response {
    let babyNickname: String
    let title: String
    let mainImageUrl: String
    let editorNoteContent: String
    let week: Int
    let day: Int
}
