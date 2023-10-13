//
//  BarNavigation.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import Foundation

protocol BarNavigation: AnyObject {
    func navigationRightButtonTapped()
    func navigationLeftButtonTapped()
}

protocol PopNavigation {
    func backButtonTapped()
}

protocol DismissNavigation {
    func closeButtonTapped()
}
