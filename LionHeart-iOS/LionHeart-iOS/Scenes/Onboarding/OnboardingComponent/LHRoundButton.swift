//
//  LHRoundButton.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHRoundButton: UIButton {
    private let cornerRadius: CGFloat
    private let title: String
    
    init(cornerRadius: CGFloat, title: String) {
        self.cornerRadius = cornerRadius
        self.title = title
        super.init(frame: .zero)
        
        self.setTitle(self.title, for: .normal)
        self.titleLabel?.font = .pretendard(.subHead2)
        self.setTitleColor(.designSystem(.white), for: .normal)
        self.backgroundColor = .designSystem(.lionRed)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
