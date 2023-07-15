//
//  LHToast.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/14.
//

import UIKit

import SnapKit

final class LHToast {
    private static let feedbackGenerator = UINotificationFeedbackGenerator()
    static func show (message: String, duration: TimeInterval = 1, completion: (() -> Void)? = nil) {
        let toastView = LHToastView(message: message)
        guard let window = UIWindow.current else { return }
        window.subviews
            .filter { $0 is LHToastView }
            .forEach { $0.removeFromSuperview() }
        window.addSubview(toastView)
        
        toastView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        window.layoutSubviews()
        self.feedbackGenerator.notificationOccurred(.success)
        
        fadeIn(completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                fadeOut(completion: {
                    completion?()
                })
            }
        })
        
        func fadeIn(completion: (() -> Void)? = nil) {
            toastView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                toastView.alpha = 1
            } completion: { _ in
                completion?()
            }

        }
        
        func fadeOut(completion: (() -> Void)? = nil) {
            toastView.alpha = 1
            UIView.animate(withDuration: 0.5) {
                toastView.alpha = 0
            } completion: { _ in
                toastView.removeFromSuperview()
                completion?()
            }
        }
    }
}

