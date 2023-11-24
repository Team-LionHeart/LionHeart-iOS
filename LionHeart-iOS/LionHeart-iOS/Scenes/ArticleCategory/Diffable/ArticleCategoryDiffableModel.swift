//
//  ArticleCategorySection.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/20/23.
//

import Foundation


enum ArticleCategorySection {
    case articleCategory
}

enum ArticleCategoryItem: Hashable {
    case category(title: CategoryImage)
}
