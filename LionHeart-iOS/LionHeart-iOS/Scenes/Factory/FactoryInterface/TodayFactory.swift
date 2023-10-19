//
//  TodayFactory.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/15.
//

import UIKit

protocol TodayFactory {
    func makeAuthAdaptor(coordinator: TodayCoordinator) -> EntireTodayNavigation
    func makeTodayViewController(coordinator: TodayCoordinator) -> TodayViewControllerable
}



