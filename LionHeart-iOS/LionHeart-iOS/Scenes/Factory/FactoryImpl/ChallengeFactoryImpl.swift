//
//  ChallengeFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

struct ChallengeFactoryImpl: ChallengeFactory {
    
    func makeAdaptor(coordinator: ChallengeCoordinator) -> EntireChallengeNavigation {
        let adaptor = ChallengeAdaptor(coordinator: coordinator)
        return adaptor
    }
    
    func makeChallengeViewModel(coordinator: ChallengeCoordinator) -> any ChallengeViewModel & ChallengeViewModelPresentable {
        let adaptor = self.makeAdaptor(coordinator: coordinator)
        let apiService = APIService()
        let serviceImpl = ChallengeServiceImpl(apiService: apiService)
        let managerImpl = ChallengeManagerImpl(challengeService: serviceImpl)
        return ChallengeViewModelImpl(navigator: adaptor, manager: managerImpl)
    }
    
    func makeChallengeViewController(coordinator: ChallengeCoordinator) -> ChallengeViewControllerable {
        let viewModel = makeChallengeViewModel(coordinator: coordinator)
        return ChallengeViewController(viewModel: viewModel)
    }
}
