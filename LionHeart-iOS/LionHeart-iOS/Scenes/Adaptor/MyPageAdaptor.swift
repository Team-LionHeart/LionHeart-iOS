//
//  MyPageAdaptor.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/19.
//

import Foundation

typealias EntireMyPageNavigation = MyPageNavigation

final class MyPageAdaptor: EntireMyPageNavigation {
    
    private let coordindator: MyPageCoordinator
    
    init(coordindator: MyPageCoordinator) {
        self.coordindator = coordindator
    }
    
    func checkTokenIsExpired() {
        coordindator.exitApplication()
    }
    
    func backButtonTapped() {
        coordindator.pop()
    }
}
