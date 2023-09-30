//
//  LHToggleImageButton.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/25.
//

import UIKit

final class LHToggleImageButton: UIButton {
    init(normal normalImage: UIImage?, select selectImage: UIImage?) {
        super.init(frame: .zero)
        self.setImage(normalImage, for: .normal)
        self.setImage(selectImage, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
