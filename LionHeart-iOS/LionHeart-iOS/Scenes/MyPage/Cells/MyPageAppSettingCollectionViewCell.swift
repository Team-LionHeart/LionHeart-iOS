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
    
    private let settingLabel = {
        let label = UILabel()
        label.font = .pretendard(.body2M)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    private let alarmSwtich = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        return switchButton
    }()
    
    private let versionLabel = {
        let label = UILabel()
        label.text = "1.0.0"
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray500)
        return label
    }()
    
    private let bottomView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray800)
        return view
    }()
    
    var inputData: String? {
        didSet {
            guard let inputData = inputData else { return }
            settingLabel.text = inputData
            
            if CellType.alaram == CellType(rawValue: inputData) {
                versionLabel.isHidden = true
            } else {
                alarmSwtich.isHidden = true
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
        addSubviews(settingLabel, alarmSwtich, versionLabel, bottomView)
    }
    
    func setLayout() {
        settingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        alarmSwtich.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
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
