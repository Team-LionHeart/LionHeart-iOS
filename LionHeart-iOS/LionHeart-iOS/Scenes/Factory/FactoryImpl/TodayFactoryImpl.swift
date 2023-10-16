//
//  TodayFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct TodayFactoryImpl: TodayFactory {
    func makeTodayViewController(adaptor: TodayNavigation) -> TodayViewControllerable {
        return TodayViewController(manager: TodayManagerImpl(articleService: ArticleServiceImpl(apiService: APIService())), adaptor: adaptor)
    }
}
