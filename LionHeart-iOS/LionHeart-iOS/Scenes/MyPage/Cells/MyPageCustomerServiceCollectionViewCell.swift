//
//  MyPageListCollectionViewCell.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/14.
//  Copyright (c) 2023 MyPageList. All rights reserved.
//

import UIKit

import SnapKit

final class MyPageCustomerServiceCollectionViewCell: UICollectionViewCell, CollectionViewCellRegisterDequeueProtocol {
    
    private let listNameLabel = LHLabel(type: .body2M, color: .white)
    private lazy var nextButton = LHImageButton(setImage: ImageLiterals.Curriculum.arrowRightSmall)
    private let bottomView = LHView(color: .designSystem(.gray800))
    
    var inputData: String? {
        didSet {
            listNameLabel.text = inputData
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyPageCustomerServiceCollectionViewCell {
    func setHierarchy() {
        addSubviews(listNameLabel, nextButton, bottomView)
    }
    
    func setLayout() {
        listNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func setAddTarget() {
        nextButton.addButtonAction { _ in
            print("눌리냐")
        }
    }
}
