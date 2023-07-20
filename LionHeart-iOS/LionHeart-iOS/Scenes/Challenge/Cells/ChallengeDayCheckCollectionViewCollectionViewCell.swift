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
    
    var textColorBool = false
    
    var inputData: DummyModel? {
        didSet {
            
        }
    }
    
    var inputString: String? {
        didSet {
            countLabel.text = inputString
            
            if textColorBool {
                countLabel.textColor = .designSystem(.white)
            } else {
                countLabel.textColor = .designSystem(.gray600)
            }
        }
    }
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .pretendard(.body2M)
        label.textColor = .designSystem(.gray700)
        return label
    }()

    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray900)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - autolayout설정
        setLayout()
        
        // MARK: - button의 addtarget설정
        setAddTarget()
        
        // MARK: - delegate설정
        setDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
}
