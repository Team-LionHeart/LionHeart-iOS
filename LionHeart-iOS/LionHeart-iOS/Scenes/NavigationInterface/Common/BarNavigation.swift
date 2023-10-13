//
//  BarNavigation.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import Foundation

/// navigationBar가 존재하는 view에서 사용하는 navigation
protocol BarNavigation: AnyObject {
    func navigationRightButtonTapped()
    func navigationLeftButtonTapped()
    func backButtonTapped()
    func closeButtonTapped()
}
