//
//  LHImageView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import UIKit

final class LHImageView: UIImageView {
    
    init(in image: UIImage? = nil) {
        super.init(frame: .zero)
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
