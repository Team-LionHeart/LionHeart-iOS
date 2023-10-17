//
//  ChallengeAdaptor.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/17/23.
//

import Foundation


final class ChallengeAdaptor: ChallengeNavigation {
    
    let coordinator: ChallengeCoordinator
    
    init(coordinator: ChallengeCoordinator) {
        self.coordinator = coordinator
    }
    
    func navigationRightButtonTapped() {
        self.coordinator.showMypageViewController()
    }
    
    func navigationLeftButtonTapped() {
        self.coordinator.showBookmarkViewController()
    }
    
    func checkTokenIsExpired() {
        self.coordinator.exitApplication()
    }
}
