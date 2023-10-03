//
//  LHImageButton.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/25.
//

import UIKit

final class LHImageButton: UIButton {
    init(setImage: UIImage?) {
        super.init(frame: .zero)
        self.setImage(setImage, for: .normal)
    }
    
    func priorty(_ priority: UILayoutPriority, _ axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentHuggingPriority(priority, for: axis)
        return self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
