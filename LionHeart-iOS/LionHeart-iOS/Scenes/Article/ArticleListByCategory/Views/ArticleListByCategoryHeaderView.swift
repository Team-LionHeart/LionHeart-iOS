//
//  ArticleListByCategoryHeaderView.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/15.
//  Copyright (c) 2023 ArticleListByCategoryHeader. All rights reserved.
//

import UIKit

import SnapKit

final class ArticleListByCategoryHeaderView: UIView {
    
    private lazy var categoryTagLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "출산 직전"
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.componentLionRed)
        label.layer.borderColor = .designSystem(.componentLionRed)
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 3
        label.topPadding = 4
        label.bottomPadding = 4
        label.leftPadding = 8
        label.rightPadding = 8
        return label
    }()
    
    private let categorytitleLabel: UILabel = {
        let label = UILabel()
        label.text = "출산 준비,\n불필요한 지출은 그만!"
        label.numberOfLines = 3
        label.font = .pretendard(.head2)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    private lazy var categorysubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "라이온하트가 전하는 예산 절약 노하우 대공개"
        label.numberOfLines = 2
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray400)
        return label
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

private extension ArticleListByCategoryHeaderView {
    func setUI() {
        self.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        self.addSubviews(categoryTagLabel, categorytitleLabel, categorysubtitleLabel)
    }
    
    func setLayout() {
        categoryTagLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.leading.equalToSuperview().inset(20)
        }
        categorytitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryTagLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        categorysubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categorytitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
}
