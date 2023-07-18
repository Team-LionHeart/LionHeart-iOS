//
//  UIApplication+.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/10.
//

import UIKit


extension UIApplication {
    static func navigationTopViewController(base: UIViewController? = UIApplication.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return navigationTopViewController(base: nav.visibleViewController)
        }
        
        if let nav = base as? UITabBarController {
            return navigationTopViewController(base: nav.viewControllers?.first)
        }
    
        return base
    }
}

extension UIApplication {
    static var keyWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first
    }
}
