//
//  LHLabel.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import UIKit

final class LHLabel: UILabel {
    
    init(type: Font.PretendardType, color: Palette, alignment: NSTextAlignment = .center) {
        super.init(frame: .zero)
        self.font = .pretendard(type)
        self.textColor = .designSystem(color)
        self.textAlignment = alignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
