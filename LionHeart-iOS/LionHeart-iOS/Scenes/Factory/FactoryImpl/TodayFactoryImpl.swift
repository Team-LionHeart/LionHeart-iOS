//
//  TodayFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct TodayFactoryImpl: TodayFactory {
    func makeTodayViewModel(coordinator: TodayCoordinator) -> any TodayViewModel & TodayViewModelPresentable {
        let adaptor = self.makeAuthAdaptor(coordinator: coordinator)
        let apiService = APIService()
        let serviceImpl = ArticleServiceImpl(apiService: apiService)
        let managerImpl = TodayManagerImpl(articleService: serviceImpl)
        return TodayViewModelImpl(navigator: adaptor, manager: managerImpl)
    }
    
    
    func makeAuthAdaptor(coordinator: TodayCoordinator) -> EntireTodayNavigation {
        return TodayAdaptor(coordinator: coordinator)
    }
    
    func makeTodayViewController(coordinator: TodayCoordinator) -> TodayViewControllerable {
        let viewModel = self.makeTodayViewModel(coordinator: coordinator)
        return TodayViewController(viewModel: viewModel)
    }
}
