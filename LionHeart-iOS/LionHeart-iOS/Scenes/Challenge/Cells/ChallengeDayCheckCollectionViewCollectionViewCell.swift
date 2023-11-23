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
    
    enum ChallengeCellType { case read, yet }
    
    private let countLabel = LHLabel(type: .body2M, color: .gray700, alignment: .center)
    private let lineView = LHUnderLine(lineColor: .gray900)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    func configure(type: ChallengeCellType, input: ChallengeData, indexPath: IndexPath) {
        switch type {
        case .read:
            countLabel.text = input.daddyAttendances[indexPath.item]
            backgroundColor = .designSystem(.background)
            countLabel.textColor = .designSystem(.white)
        case .yet:
            countLabel.text = "\(indexPath.section + indexPath.row + 1)"
            backgroundColor = .designSystem(.gray1000)
        }
    }
}

private extension ChallengeDayCheckCollectionViewCollectionViewCell {

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
