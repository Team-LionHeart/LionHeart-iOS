//
//  OnboardingViewControllerable.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

protocol OnboardingViewControllerable where Self: UIViewController {
    var coordinator: OnboardingNavigation? { get set }
    func setKakaoAccessToken(_ token: String?)
}
