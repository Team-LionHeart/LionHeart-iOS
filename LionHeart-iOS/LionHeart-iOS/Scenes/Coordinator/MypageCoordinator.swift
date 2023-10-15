//
//  MypageCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class MypageCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    let factory: MyPageFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: MyPageFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showMypageViewController()
    }
    
    func showMypageViewController() {
        let myPageViewController = factory.makeMyPageViewController()
        myPageViewController.coordinator = self
        self.navigationController.pushViewController(myPageViewController, animated: true)
    }
}

extension MypageCoordinator: MyPageNavigation {
    func backButtonTapped() {
        self.navigationController.popViewController(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
