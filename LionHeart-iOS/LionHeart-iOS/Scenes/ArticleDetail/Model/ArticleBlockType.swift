//
//  ArticleBlockType.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/11.
//

import UIKit

struct ArticleBlockData: Hashable, AppData {
    let content: String
    let caption: String?
}

@frozen
enum BlockTypeAppData: Hashable {
    case thumbnail(isMarked: Bool, model: ArticleBlockData)
    case articleTitle(model: ArticleBlockData)
    case editorNote(model: ArticleBlockData)
    case chapterTitle(model: ArticleBlockData)
    case body(model: ArticleBlockData)
    case generalTitle(model: ArticleBlockData)
    case image(model: ArticleBlockData)
    case endNote
    case none
}
