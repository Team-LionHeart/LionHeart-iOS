//
//  UIStackView+.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//

import UIKit

extension UIStackView {
     func addArrangedSubviews(_ views: UIView...) {
         for view in views {
             self.addArrangedSubview(view)
         }
     }
}

