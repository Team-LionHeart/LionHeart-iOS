//
//  OnboardingNavigation.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol OnboardingNavigation: ExpireNavigation, PopNavigation {
    func onboardingCompleted(data: UserOnboardingModel)
}
