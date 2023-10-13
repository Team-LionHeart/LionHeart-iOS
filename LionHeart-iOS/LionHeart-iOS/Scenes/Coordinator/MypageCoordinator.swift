//
//  MypageCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class MypageCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMypageViewController()
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
    }
    
    func showMypageViewController() {
        let myPageViewController = MyPageViewController(manager: MyPageManagerImpl(mypageService: MyPageServiceImpl(apiService: APIService()), authService: AuthServiceImpl(apiService: APIService())))
        myPageViewController.coordinator = self
        self.navigationController.pushViewController(myPageViewController, animated: true)
    }
}

extension MypageCoordinator: MyPageNavigation {
    func checkTokenIsExpired() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    func backButtonTapped() {
        self.navigationController.popViewController(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
