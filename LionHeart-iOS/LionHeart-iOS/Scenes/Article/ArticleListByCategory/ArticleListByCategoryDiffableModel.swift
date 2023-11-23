//
//  ArticleListByCategoryDiffableModel.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/20/23.
//

import Foundation


enum ArticleListByCategorySection {
    case article
}

enum ArticleListByCategoryItem: Hashable {
    case article(data: ArticleDataByWeek)
}
