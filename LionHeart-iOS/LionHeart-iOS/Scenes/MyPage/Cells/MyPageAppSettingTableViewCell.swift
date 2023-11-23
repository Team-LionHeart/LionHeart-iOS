//
//  MyPageAppSettingTableViewCell.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/20.
//

import UIKit

import SnapKit

enum CellType: String {
    case alaram = "알림 설정"
    case version = "앱 버전"
}

final class MyPageAppSettingTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .designSystem(.background)
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyPageAppSettingTableViewCell {
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
