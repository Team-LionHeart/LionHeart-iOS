//
//  UIView+.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//

import UIKit

extension UIView {
    
    // UIView 여러 개 인자로 받아서 한 번에 addSubview
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func setGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.init(white: 1, alpha: 0).cgColor, UIColor.init(white: 1, alpha: 1).cgColor]
        gradient.locations = [0.0, 0.8, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.2)
        gradient.endPoint = CGPoint(x: 1.0, y: 1)
        layer.insertSublayer(gradient, at: 0)
    }
    
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}

extension UIView {
    public func makeVibrate(degree: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: degree)
        generator.impactOccurred()
    }
}
