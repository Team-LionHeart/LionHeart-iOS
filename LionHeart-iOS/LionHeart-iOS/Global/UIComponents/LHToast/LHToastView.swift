//
//  LHToastView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/14.
//

import UIKit

final class LHToastView: UIView {
    
    private let messageLabel = UILabel()
    
    init(message: String, backgroundColor: UIColor? = .designSystem(.gray800), messageColor: UIColor? = .designSystem(.white)) {
        super.init(frame: .zero)

        self.messageLabel.textColor = messageColor
        self.messageLabel.text = message
        self.backgroundColor = backgroundColor?.withAlphaComponent(0.8)
        self.setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LHToastView {
    private func setUI() {
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.messageLabel.font = .pretendard(.body3R)
        self.messageLabel.textAlignment = .center

        self.addSubview(messageLabel)
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        self.messageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
