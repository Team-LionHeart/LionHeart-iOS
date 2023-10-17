//
//  CurriculumListCoordinator.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/17/23.
//

import Foundation


protocol CurriculumListCoordinator: Coordinator {
    func showArticleDetailViewController(articleId: Int)
    func pop()
    func exitApplication()
}
