//
//  MypageCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class MypageCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMypageViewController()
    }
    
    func showMypageViewController() {
        let myPageViewController = MyPageViewController(manager: MyPageManagerImpl(mypageService: MyPageServiceImpl(apiService: APIService()), authService: AuthServiceImpl(apiService: APIService())))
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
