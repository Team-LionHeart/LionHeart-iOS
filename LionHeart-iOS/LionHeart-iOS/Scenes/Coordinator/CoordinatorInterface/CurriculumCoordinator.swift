//
//  CurriculumCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

protocol CurriculumCoordinator: Coordinator {
    func showCurriculumViewController()
    func showCurriculumListViewController(itemIndex: Int)
    func showMypageViewController()
    func showBookmarkViewController()
    func showArticleDetailViewController(articleId: Int)
    func pop()
    func exitApplication()
}
