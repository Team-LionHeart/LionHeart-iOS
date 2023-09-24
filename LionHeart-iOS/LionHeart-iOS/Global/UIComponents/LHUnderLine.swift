//
//  LHUnderLine.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHUnderLine: UIView {
    
    private let lineColor: UIColor?
    
    init(lineColor: UIColor?) {
        self.lineColor = lineColor
        super.init(frame: .zero)
        self.backgroundColor = self.lineColor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
