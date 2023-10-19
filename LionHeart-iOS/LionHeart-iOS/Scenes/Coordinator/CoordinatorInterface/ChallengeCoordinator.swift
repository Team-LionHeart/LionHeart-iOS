//
//  ChallengeCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

protocol ChallengeCoordinator: Coordinator {
    func showChallengeViewController()
    func showMypageViewController()
    func showBookmarkViewController()
    func exitApplication()
}
