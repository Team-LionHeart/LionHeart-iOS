//
//  LHCollectionView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import UIKit

final class LHCollectionView: UICollectionView {
    
    init(color: UIColor? = .designSystem(.background), scroll: Bool = true) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.backgroundColor = color
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled = scroll
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
