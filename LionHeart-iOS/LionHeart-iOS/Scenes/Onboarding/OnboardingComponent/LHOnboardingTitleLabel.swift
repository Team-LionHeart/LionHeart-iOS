//
//  LHOnboardingTitleLabel.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHOnboardingTitleLabel: UILabel {
    
    init(_ content: String?, align: NSTextAlignment) {
        super.init(frame: .zero)
        self.font = .pretendard(.head2)
        self.textColor = .designSystem(.white)
        self.numberOfLines = 2
        self.text = content
        self.textAlignment = align
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

