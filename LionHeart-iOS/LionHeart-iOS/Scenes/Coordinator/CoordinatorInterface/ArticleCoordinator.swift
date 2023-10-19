//
//  ArticleCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

protocol ArticleCoordinator: Coordinator {
    func showArticleDetailViewController()
    func exitApplication()
    func dimiss()
}
