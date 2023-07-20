//
//  LHTodayArticleTitle.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHTodayArticleTitle: UILabel {
    
    var userNickName: String? {
        didSet {
            guard let userNickName else { return }
            self.text = userNickName + "님,"
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.font = .pretendard(.head1)
        self.textColor = .designSystem(.white)
        self.numberOfLines = 1
    }
    
    init(initalizeString: String) {
        super.init(frame: .zero)
        self.font = .pretendard(.head1)
        self.textColor = .designSystem(.white)
        self.text = initalizeString
        self.numberOfLines = 1
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
