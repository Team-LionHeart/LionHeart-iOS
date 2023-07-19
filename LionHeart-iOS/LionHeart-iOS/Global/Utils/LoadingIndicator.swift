//
//  LoadingIndicator.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/20.
//

import UIKit


final class LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.keyWindow else { return }

            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                loadingIndicatorView.color = .designSystem(.lionRed)
                loadingIndicatorView.backgroundColor = .designSystem(.black)
                loadingIndicatorView.frame = window.frame
                window.addSubview(loadingIndicatorView)
            }
            loadingIndicatorView.startAnimating()
        }

    }

    static func hideLoading() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.last else { return }
            window.subviews
                .filter { $0 is UIActivityIndicatorView }
                .forEach { $0.removeFromSuperview() }
        }

    }
}
