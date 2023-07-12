//
//  LHProgressView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHProgressView: UIProgressView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.progressViewStyle = .bar
        self.progressTintColor = .designSystem(.lionRed)
        self.backgroundColor = .designSystem(.gray800)
        self.transform = self.transform.scaledBy(x: 1, y: 1.5)
        self.progress = 0
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
