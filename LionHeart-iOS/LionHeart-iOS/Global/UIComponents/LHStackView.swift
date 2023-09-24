//
//  LHStackView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/25.
//

import UIKit

final class LHStackView: UIStackView {
    
    init(axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
