//
//  UIWindow+.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/14.
//

import UIKit

extension UIWindow {
    public static var current: UIWindow? {
        UIApplication.shared.windows.first(where: \.isKeyWindow)
    }
}
