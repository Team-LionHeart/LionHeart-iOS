//
//  UIPageViewController+.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

extension UIPageViewController {
    
    func disableSwipeGesture() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
}
