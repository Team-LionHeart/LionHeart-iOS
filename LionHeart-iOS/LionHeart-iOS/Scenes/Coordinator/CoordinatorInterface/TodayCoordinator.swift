//
//  TodayCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import Foundation

protocol TodayCoordinator: Coordinator {
    func showTodayViewController()
    func showArticleDetaileViewController(articleID: Int)
    func showMypageViewController()
    func showBookmarkViewController()
    func exitApplication()
}




