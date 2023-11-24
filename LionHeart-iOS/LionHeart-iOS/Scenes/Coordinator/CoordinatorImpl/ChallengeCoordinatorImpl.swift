//
//  ChallengeCoordinatorImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/17/23.
//

import UIKit


final class ChallengeCoordinatorImpl: ChallengeCoordinator {

    weak var parentCoordinator: Coordinator?
    private let factory: ChallengeFactory
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: ChallengeFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func showChallengeViewController() {
        let challengeViewController = factory.makeChallengeViewController(coordinator: self)
        navigationController.pushViewController(challengeViewController, animated: true)
    }
    
    func showMypageViewController() {
        let mypageCoordinator = MyPageCoordinatorImpl(navigationController: navigationController,
                                                  factory: MyPageFactoryImpl())
        mypageCoordinator.showMyPageViewController()
        children.append(mypageCoordinator)
    }
    
    func showBookmarkViewController() {
        let bookmakrFactory = BookmarkFactoryImpl()
        let bookmarkCoordinator = BookmarkCoordinatorImpl(navigationController: navigationController, factory: bookmakrFactory)
        bookmarkCoordinator.showBookmarkViewController()
        children.append(bookmarkCoordinator)
    }
    
    func exitApplication() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}
