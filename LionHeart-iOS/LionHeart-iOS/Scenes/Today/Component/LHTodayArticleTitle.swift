//
//  LHTodayArticleTitle.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHTodayArticleTitle: UILabel {
    
    var title: String? {
        didSet {
            self.text = title
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.font = .pretendard(.head1)
        self.textColor = .designSystem(.white)
        self.numberOfLines = 2
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
