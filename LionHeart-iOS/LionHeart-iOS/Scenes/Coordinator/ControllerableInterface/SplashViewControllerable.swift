//
//  SplashViewControllerable.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

protocol SplashViewControllerable where Self: UIViewController {
    var coordinator: SplashNavigation? { get set }
}
