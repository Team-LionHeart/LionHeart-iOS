//
//  CurriculumProgessTableViewHeaderView.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/12.
//  Copyright (c) 2023 CurriculumProgessTableViewHeader. All rights reserved.
//

import UIKit

import SnapKit

final class CurriculumProgessTableViewHeaderView: UIView {
    
    private let progressBar: UIProgressView = {
        let proView = UIProgressView()
        proView.setProgress(0.1, animated: true)
        proView.progress = 0.1
        proView.trackTintColor = .white
        proView.progressTintColor = .red
        return proView
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

private extension CurriculumProgessTableViewHeaderView {
    func setUI() {
        
    }
    
    func setHierarchy() {
        
    }
    
    func setLayout() {
        
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
}
