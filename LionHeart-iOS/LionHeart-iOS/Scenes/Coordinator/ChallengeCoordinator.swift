//
//  ChallengeCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class ChallengeCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    private let factory: ChallengeFactory
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: ChallengeFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showChallengeViewController()
    }
    
    func showChallengeViewController() {
        let challengeViewController = factory.makeChallengeViewController()
        challengeViewController.coordinator = self
        navigationController.pushViewController(challengeViewController, animated: true)
    }
}

extension ChallengeCoordinator: ChallengeNavigation {
    func navigationRightButtonTapped() {
        let mypageCoordinator = MypageCoordinator(navigationController: navigationController)
        mypageCoordinator.start()
        children.append(mypageCoordinator)
    }
    
    func navigationLeftButtonTapped() {
        let bookmarkCoordinator = BookmarkCoordinator(navigationController: navigationController)
        bookmarkCoordinator.start()
        children.append(bookmarkCoordinator)
    }
}
