//
//  LHLabel.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import UIKit

final class LHLabel: UILabel {
    
    init(type: Font.PretendardType,
         color: Palette,
         backgroundColor: Palette? = nil,
         alignment: NSTextAlignment = .left,
         lines: Int = 1,
         basicText: String? = nil) {
        super.init(frame: .zero)
        self.font = .pretendard(type)
        self.textColor = .designSystem(color)
        self.textAlignment = alignment
        self.text = basicText
        self.backgroundColor = .designSystem(.background)
        self.numberOfLines = lines
    }
    
    func priorty(_ priority: UILayoutPriority, _ axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentHuggingPriority(priority, for: axis)
        return self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
