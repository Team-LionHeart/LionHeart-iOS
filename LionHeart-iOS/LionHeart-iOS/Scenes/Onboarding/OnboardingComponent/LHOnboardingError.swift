//
//  LHOnboardingError.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHOnboardingError: UILabel {
    
    init() {
        super.init(frame: .zero)
        self.font = .pretendard(.body4)
        self.textColor = .designSystem(.componentLionRed)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
