//
//  TodayFactory.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/15.
//

import UIKit

protocol TodayFactory {
    func makeAuthAdaptor(coordinator: TodayCoordinator) -> EntireTodayNavigation
    func makeTodayViewModel(coordinator: TodayCoordinator) -> any TodayViewModel & TodayViewModelPresentable
    func makeTodayViewController(coordinator: TodayCoordinator) -> TodayViewControllerable
}



