//
//  MyPageFactory.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation

protocol MyPageFactory {
    func makeAdaptor(coordinator: MyPageCoordinator) -> EntireMyPageNavigation
    func makeMyPageViewModel(coordinator: MyPageCoordinator) -> any MyPageViewModel & MyPageViewModelPresentable
    func makeMyPageViewController(coordinator: MyPageCoordinator) -> MyPageControllerable
}
