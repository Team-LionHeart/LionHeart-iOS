//
//  BookmarkCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit


protocol BookmarkCoordinator: Coordinator {
    func showArticleDetailViewController(articleId: Int)
    func showBookmarkViewController()
    func pop()
    func exitApplication()
}
