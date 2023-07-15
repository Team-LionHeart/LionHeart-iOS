//
//  UICollectionView+.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/12.
//

import UIKit

import SnapKit

extension UICollectionView {
    func setEmptyView(emptyText: String) {
        let emptyView: UIView = {
            let view = UIView(frame: CGRect(x: self.center.x, y: self.center.y,
                                            width: Constant.Screen.width, height: Constant.Screen.width))
            return view
        }()
        
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = emptyText
            label.numberOfLines = 0
            label.font = .pretendard(.body2R)
            label.textColor = .designSystem(.gray600)
            return label
        }()
        
        emptyView.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
