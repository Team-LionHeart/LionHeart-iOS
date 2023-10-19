//
//  ChallengeFactory.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

protocol ChallengeFactory {
    func makeAdaptor(coordinator: ChallengeCoordinator) -> EntireChallengeNavigation
    func makeChallengeViewController(coordinator: ChallengeCoordinator) -> ChallengeViewControllerable
}
