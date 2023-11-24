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
    
    private let categoryTagLabel: UILabelPadding = {
        let label = UILabelPadding(padding: .init(top: 4, left: 8, bottom: 4, right: 8))
        label.text = "출산 직전"
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.componentLionRed)
        label.layer.borderColor = .designSystem(.componentLionRed)
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 3
        return label
    }()
    
    private let categorytitleLabel = LHLabel(type: .head2, color: .white, lines: 3, basicText: "출산 준비,\n불필요한 지출은 그만!")
    private let categorysubtitleLabel = LHLabel(type: .body3R, color: .gray400, lines: 2, basicText: "라이온하트가 전하는 예산 절약 노하우 대공개")
    
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
}
