//
//  TodayFactory.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/15.
//

import UIKit

protocol TodayFactory {
    func makeTodayViewModel(coordinator: TodayCoordinator) -> any TodayViewModel & TodayViewModelPresentable
    func makeAuthAdaptor(coordinator: TodayCoordinator) -> EntireTodayNavigation
    func makeTodayViewController(coordinator: TodayCoordinator) -> TodayViewControllerable
}



