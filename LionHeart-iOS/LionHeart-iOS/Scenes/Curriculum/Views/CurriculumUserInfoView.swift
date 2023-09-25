//
//  CurriculumUserInfoView.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/12.
//  Copyright (c) 2023 CurriculumUserInfo. All rights reserved.
//

import UIKit

import SnapKit

final class CurriculumUserInfoView: UIView {
    
    private let weekImageView = LHImageView()
    private let userWeekLabel = LHLabel(type: .head3, color: .gray100)
    private let weekLabel = LHLabel(type: .head3, color: .white, basicText: "주")
    private let dayImageView = LHImageView(in: ImageLiterals.Curriculum.dayBackground)
    private let userDayLabel = LHLabel(type: .head3, color: .gray100, alignment: .center)
    private let dayLabel = LHLabel(type: .head3, color: .white, basicText: "일차")
    private let userWeekDayInfoView = LHImageView()
    
    var userInfo: UserInfoData? {
        didSet {
            configureUserInfo(data: userInfo)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    override func layoutSubviews() {
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUserInfo(data: UserInfoData?) {
        guard let data else { return }
        self.userWeekLabel.text = "\(data.userWeekInfo)"
        self.userDayLabel.text = "\(data.userDayInfo)"
        weekImageView.image = data.userWeekInfo.description.count >= 2 ? ImageLiterals.Curriculum.weekBackground : ImageLiterals.Curriculum.dayBackground
    }
    
}

extension CurriculumUserInfoView {
    
    func setUI() {
        self.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        self.addSubviews(userWeekDayInfoView, weekImageView, userWeekLabel, weekLabel, dayImageView, userDayLabel, dayLabel)
        dayImageView.addSubview(userDayLabel)
    }
    
    func setLayout() {
        
        weekImageView.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(24)
        }
        
        userWeekLabel.snp.makeConstraints{
            $0.centerX.equalTo(weekImageView)
            $0.centerY.equalTo(weekImageView)
        }
        
        weekLabel.snp.makeConstraints{
            $0.leading.equalTo(weekImageView.snp.trailing).offset(6)
            $0.centerY.equalTo(userWeekLabel)
        }
        
        dayImageView.snp.makeConstraints{
            $0.leading.equalTo(weekLabel.snp.trailing).offset(8)
            $0.top.equalToSuperview().inset(24)
        }
        
        userDayLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        dayLabel.snp.makeConstraints{
            $0.leading.equalTo(dayImageView.snp.trailing).offset(6)
            $0.centerY.equalTo(userWeekLabel)
        }
        
    }
}
