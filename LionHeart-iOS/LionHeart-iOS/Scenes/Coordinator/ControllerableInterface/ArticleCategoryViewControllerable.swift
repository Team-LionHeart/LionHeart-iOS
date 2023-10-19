//
//  ArticleCategoryViewControllerable.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

protocol ArticleCategoryViewControllerable where Self: UIViewController {
    var navigator: ArticleCategoryNavigation {get set}
}
