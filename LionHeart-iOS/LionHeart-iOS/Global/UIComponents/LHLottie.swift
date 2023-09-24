//
//  LHLottie.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation
import Lottie

final class LHLottie: LottieAnimationView {
    init() {
        super.init(frame: .zero)
        self.contentMode = .scaleToFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
