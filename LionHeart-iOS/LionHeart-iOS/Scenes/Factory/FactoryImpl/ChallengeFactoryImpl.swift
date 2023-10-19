//
//  ChallengeFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

struct ChallengeFactoryImpl: ChallengeFactory {
    func makeAdaptor(coordinator: ChallengeCoordinator) -> ChallengeAdaptor {
        let adaptor = ChallengeAdaptor(coordinator: coordinator)
        return adaptor
    }
    
    func makeChallengeViewController(coordinator: ChallengeCoordinator) -> ChallengeViewControllerable {
        let adaptor = self.makeAdaptor(coordinator: coordinator)
        return ChallengeViewController(manager: ChallengeManagerImpl(challengeService: ChallengeServiceImpl(apiService: APIService())), navigator: adaptor)
    }
}
