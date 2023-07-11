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
    
    static var identifier = "CurriculumTableViewHeaderViewView"
    
    var headerNameLabel: UILabel = {
        let header = UILabel()
        header.font = .pretendard(.head2)
        header.textColor = .designSystem(.white)
        return header
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
    
    func configureHeaderView(month: String){
        headerNameLabel.text = month
    }
}

private extension CurriculumTableViewHeaderView {
    func setUI() {
    }
    
    func setHierarchy() {
        contentView.addSubview(headerNameLabel)
    }
    
    func setLayout() {
        headerNameLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
    
    
}
