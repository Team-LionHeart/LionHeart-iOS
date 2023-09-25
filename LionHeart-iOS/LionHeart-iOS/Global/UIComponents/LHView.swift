//
//  LHView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/25.
//

import UIKit

final class LHView: UIView {
    init(color: UIColor?) {
        super.init(frame: .zero)
        self.backgroundColor = color
    }
    
    func makeRound(_ ratio: CGFloat) -> Self {
        self.clipsToBounds = true
        self.layer.cornerRadius = ratio
        return self
    }
    
    func opacity(_ ratio: Float) -> Self {
        self.layer.opacity = ratio
        return self
    }
    
    func maskedCorners(corners: CACornerMask) -> Self {
        self.layer.maskedCorners = corners
        return self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

