//
//  MyPageCoordinatorImpl.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/19.
//

import UIKit

final class MyPageCoordinatorImpl: MyPageCoordinator {
    
    weak var parentCoordinator: Coordinator?
    private let factory: MyPageFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: MyPageFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showMyPageViewController()
    }
    
    func showMyPageViewController() {
        let myPageViewController = factory.makeMyPageViewController(coordinator: self)
        self.navigationController.pushViewController(myPageViewController, animated: true)
    }
    
    func exitApplication() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    func pop() {
        self.navigationController.popViewController(animated: true)
        self.parentCoordinator?.childDidFinish(self)
    }
}
