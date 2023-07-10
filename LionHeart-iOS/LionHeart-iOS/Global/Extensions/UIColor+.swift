//
//  UIColor+.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/10.
//

import UIKit

extension UIColor {
    static func designSystem(_ color: Palette) -> UIColor? {
        UIColor(named: color.rawValue)
    }
}
