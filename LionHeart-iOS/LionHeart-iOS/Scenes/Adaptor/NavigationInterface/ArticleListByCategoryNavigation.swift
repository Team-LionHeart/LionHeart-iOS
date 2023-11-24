//
//  ArticleListByCategoryNavigation.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol ArticleListByCategoryNavigation: ExpireNavigation, PopNavigation {
    func articleListByCategoryCellTapped(articleID: Int)
}
