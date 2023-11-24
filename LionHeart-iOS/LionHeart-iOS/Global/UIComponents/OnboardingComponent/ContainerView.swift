//
//  ContainerView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class ContainerView: UIView {
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
