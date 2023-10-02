//
//  LHLottie.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation
import Lottie

final class LHLottie: LottieAnimationView {
    init(name: String? = nil) {
        super.init(frame: .zero)
        self.contentMode = .scaleAspectFill
        if let name {
//            guard let lottie = LottieAnimation.named(name) else { return }
            self.animation = .named(name)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
