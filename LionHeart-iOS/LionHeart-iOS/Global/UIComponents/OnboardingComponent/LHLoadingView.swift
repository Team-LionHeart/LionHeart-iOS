//
//  LHLoadingView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/20.
//

import UIKit

final class LHLoadingView: UIActivityIndicatorView {
    
    init() {
        super.init(frame: .zero)
        self.style = .large
        self.color = .designSystem(.lionRed)
        self.backgroundColor = .designSystem(.black)
        self.frame = .init(x: 0, y: 0, width: Constant.Screen.width, height: Constant.Screen.height)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
