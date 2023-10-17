//
//  SplashAdaptor.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/17.
//

import Foundation

final class SplashAdaptor: SplashNavigation {
    
    let coordinator: SplashCoordinator
    init(coordinator: SplashCoordinator) {
        self.coordinator = coordinator
    }
    
    func checkToken(state: TokenState) {
        switch state {
        case .valid:
            coordinator.showTabbarViewContoller()
        case .expired:
            coordinator.showLoginViewController()
        }
    }
}
