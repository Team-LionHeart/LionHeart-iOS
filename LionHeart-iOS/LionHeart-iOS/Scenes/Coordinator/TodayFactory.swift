//
//  TodayFactory.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/15.
//

import UIKit

protocol TodayFactory {
    func makeTodayViewController() -> TodayViewControllerable
}

struct TodayFactoryImpl: TodayFactory {
    func makeTodayViewController() -> TodayViewControllerable {
        return TodayViewController(manager: TodayManagerImpl(articleService: ArticleServiceImpl(apiService: APIService())))
    }
}

