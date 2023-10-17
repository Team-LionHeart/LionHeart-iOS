//
//  ChallengeFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

struct ChallengeFactoryImpl: ChallengeFactory {
    func makeChallengeViewController(adaptor: ChallengeAdaptor) -> ChallengeViewControllerable {
        return ChallengeViewController(manager: ChallengeManagerImpl(challengeService: ChallengeServiceImpl(apiService: APIService())), navigator: adaptor)
    }
}
