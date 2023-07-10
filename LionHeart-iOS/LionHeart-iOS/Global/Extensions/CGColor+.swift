//
//  CGColor+.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/10.
//

import UIKit

extension CGColor {
    static func designSystem(_ color: Palette) -> CGColor? {
        UIColor(named: color.rawValue)?.cgColor
    }
}
