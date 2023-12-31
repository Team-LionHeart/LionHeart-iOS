//
//  LHOnboardingPageViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHOnboardingPageViewController: UIPageViewController {
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.disableSwipeGesture()
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation)
        self.disableSwipeGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
