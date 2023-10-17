//
//  SpalshFactory.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/15.
//

import UIKit

protocol SplashFactory {
    func makeSplashViewController(adaptor: SplashNavigation) -> SplashViewControllerable
}


