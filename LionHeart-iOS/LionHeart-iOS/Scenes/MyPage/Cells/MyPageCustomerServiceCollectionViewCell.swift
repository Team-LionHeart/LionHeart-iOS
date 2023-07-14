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
    
    private let listNameLabel = {
        let label = UILabel()
        label.font = .pretendard(.body2M)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    private lazy var nextButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiterals.Curriculum.arrowRightSmall
        let button = UIButton(configuration: configuration)
        button.addButtonAction { _ in
            print("눌리냐")
        }
        return button
    }()
    
    private let bottomView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray800)
        return view
    }()
    
    var inputData: MyPageData? {
        didSet {
            configureData(inputData)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setAddTarget()
        setDelegate()
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
        
    }
    
    func setDelegate() {
        
    }
    
    func configureData(_ model: MyPageData?) {
        guard let model = model else { return }
        listNameLabel.text =  model.titleLabel
    }
}
