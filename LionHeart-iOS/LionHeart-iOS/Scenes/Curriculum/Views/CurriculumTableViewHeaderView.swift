//
//  CurriculumTableViewHeaderViewView.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/11.
//  Copyright (c) 2023 CurriculumTableViewHeaderView. All rights reserved.
//

import UIKit

import SnapKit

final class CurriculumTableViewHeaderView: UITableViewHeaderFooterView {
    
    private var headerNameLabel = LHLabel(type: .head2, color: .white)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeaderView(month: String){
        headerNameLabel.text = month
    }
}

private extension CurriculumTableViewHeaderView {
    
    func setHierarchy() {
        contentView.addSubview(headerNameLabel)
    }
    
    func setLayout() {
        headerNameLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}
