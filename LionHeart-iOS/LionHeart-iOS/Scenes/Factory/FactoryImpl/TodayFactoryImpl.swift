//
//  TodayFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct TodayFactoryImpl: TodayFactory {
    func makeAuthAdaptor(coordinator: TodayCoordinator) -> EntireTodayNavigation {
        return TodayAdaptor(coordinator: coordinator)
    }
    
    func makeTodayViewController(coordinator: TodayCoordinator) -> TodayViewControllerable {
        return TodayViewController(manager: TodayManagerImpl(articleService: ArticleServiceImpl(apiService: APIService())), adaptor: TodayAdaptor(coordinator: coordinator))
    }
}
