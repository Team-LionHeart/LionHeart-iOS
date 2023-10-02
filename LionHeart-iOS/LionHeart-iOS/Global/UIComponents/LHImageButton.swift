//
//  LHImageButton.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/25.
//

import UIKit

final class LHImageButton: UIButton {
    init(setImage: UIImage?) {
        super.init(frame: .zero)
        self.setImage(setImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    func setTitle(font: Font.PretendardType, text: String, color: Palette) -> Self {
        self.titleLabel?.font = .pretendard(.subHead2)
        self.setTitle(text, for: .normal)
        self.setTitleColor(.designSystem(color), for: .normal)
        return self
    }

    @discardableResult
    func setCornerRadius(for radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        return self
    }
    
    @discardableResult
    func setMarginImageWithText(for margin: CGFloat) -> Self {
        self.marginImageWithText(margin: margin)
        return self
    }

    @discardableResult
    func setBackgroundColor(color: Palette) -> Self {
        self.backgroundColor = .designSystem(color)
        return self
    }
}
