//
//  LHUnderLine.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHUnderLine: UIView {
    
    init(lineColor: Palette) {
        super.init(frame: .zero)
        self.backgroundColor = .designSystem(lineColor)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
