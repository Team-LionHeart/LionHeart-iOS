//
//  TodayFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct TodayFactoryImpl: TodayFactory {
    func makeTodayViewController() -> TodayViewControllerable {
        return TodayViewController(manager: TodayManagerImpl(articleService: ArticleServiceImpl(apiService: APIService())))
    }
}
