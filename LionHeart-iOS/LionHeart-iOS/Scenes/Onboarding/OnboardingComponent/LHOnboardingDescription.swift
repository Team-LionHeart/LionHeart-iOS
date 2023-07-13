//
//  LHOnboardingDescription.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHOnboardingDescription: UILabel {
    
    private let content: String
    
    init(_ content: String) {
        self.content = content
        super.init(frame: .zero)
        self.font = .pretendard(.body3R)
        self.textColor = .designSystem(.gray400)
        self.text = self.content
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
