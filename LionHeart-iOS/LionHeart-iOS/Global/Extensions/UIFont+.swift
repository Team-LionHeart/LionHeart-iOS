//
//  UIFont+.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/10.
//

import UIKit

extension UIFont {
    
    public class func pretendard(_ type: Font.PretendardType) -> UIFont {
        let font = Font.PretendardFont(name: .pretendard, weight: type.Wight)
        return ._font(name: font.name, size: type.Size)
    }
    
    private static func _font(name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            return .systemFont(ofSize: size)
        }
        return font
    }
}

