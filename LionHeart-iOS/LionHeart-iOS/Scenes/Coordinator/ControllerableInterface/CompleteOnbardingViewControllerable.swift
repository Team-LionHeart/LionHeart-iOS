//
//  CompleteOnbardingViewControllerable.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

protocol CompleteOnbardingViewControllerable where Self: UIViewController {
    var coordinator: CompleteOnbardingNavigation? { get set }
    var userData: UserOnboardingModel? { get set }
}
