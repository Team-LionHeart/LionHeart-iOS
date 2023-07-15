//
//  LHTodayArticleTitle.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHTodayArticleTitle: UILabel {
    
    private let title: String
    
    init(nickName: String) {
        self.title = nickName + " 아빠님,\n오늘의 아티클이에요"
        super.init(frame: .zero)
        self.text = title
        self.font = .pretendard(.head1)
        self.textColor = .designSystem(.white)
        self.numberOfLines = 2
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
