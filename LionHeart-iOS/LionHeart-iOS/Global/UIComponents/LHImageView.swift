//
//  LHImageView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import UIKit

final class LHImageView: UIImageView {
    
    init(in image: UIImage? = nil, contentMode: UIView.ContentMode) {
        super.init(frame: .zero)
        self.image = image
        self.contentMode = contentMode
        self.clipsToBounds = true
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
