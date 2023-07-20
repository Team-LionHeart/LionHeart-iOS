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

extension UIView{
    
    enum GradientAxis {
        case vertical
        case horizontal
    }
    
    func setGradient(firstColor: UIColor, secondColor: UIColor, axis: GradientAxis){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        if axis == .horizontal {
            gradient.locations = [0.0 , 1.0]
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        } else if axis == .vertical {
            gradient.type = .axial
        }
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
    
    func removeGradient() {
        self.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
    }
}
