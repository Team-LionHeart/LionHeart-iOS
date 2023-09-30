//
//  challengeDayCheckCollectionViewCollectionViewCell.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/14.
//  Copyright (c) 2023 challengeDayCheckCollectionView. All rights reserved.
//

import UIKit

import SnapKit

final class ChallengeDayCheckCollectionViewCollectionViewCell: UICollectionViewCell, CollectionViewCellRegisterDequeueProtocol {
    
    private let countLabel = LHLabel(type: .body2M, color: .gray700, alignment: .center)
    private let lineView = LHUnderLine(lineColor: .gray900)
    
    var inputString: String?
    var whiteTextColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        countLabel.font = .pretendard(.body2M)
        countLabel.textColor = .designSystem(.gray700)
    }
}

private extension ChallengeDayCheckCollectionViewCollectionViewCell {
    func setUI() {
        backgroundColor = .designSystem(.gray1000)
    }
    
    func setHierarchy() {
        contentView.addSubviews(countLabel, lineView)
    }
    
    func setLayout() {
        countLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
