//
//  ArticleCategoryNavigation.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol ArticleCategoryNavigation: ExpireNavigation, BarNavigation {
    func articleListCellTapped(categoryName: String)
}
