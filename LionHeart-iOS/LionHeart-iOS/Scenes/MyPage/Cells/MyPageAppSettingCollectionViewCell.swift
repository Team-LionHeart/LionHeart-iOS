//
//  MyPageAppSettingCollectionViewCell.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/14.
//  Copyright (c) 2023 MyPageAppSetting. All rights reserved.
//

enum CellType: String {
    case alaram = "알림 설정"
    case version = "앱 버전"
}

import UIKit

import SnapKit

final class MyPageAppSettingCollectionViewCell: UICollectionViewCell, CollectionViewCellRegisterDequeueProtocol {
    
    private let settingLabel = LHLabel(type: .body2M, color: .white)
    private let versionLabel = LHLabel(type: .body3R, color: .gray500)
    private let bottomView = LHUnderLine(lineColor: .gray800)
    
    var inputData: String? {
        didSet {
            guard let inputData = inputData else { return }
            settingLabel.text = inputData
            
            if CellType.alaram == CellType(rawValue: inputData) {
                versionLabel.isHidden = true
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyPageAppSettingCollectionViewCell {
    func setHierarchy() {
        addSubviews(settingLabel, versionLabel, bottomView)
    }
    
    func setLayout() {
        settingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        versionLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
