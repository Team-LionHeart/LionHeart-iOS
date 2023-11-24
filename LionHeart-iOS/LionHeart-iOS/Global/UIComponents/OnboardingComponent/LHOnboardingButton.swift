//
//  LHOnboardingButton.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHOnboardingButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitle("다음", for: .normal)
        self.backgroundColor = .designSystem(.lionRed)
        self.isHidden = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
