//
//  ChallengeViewController.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/13.
//  Copyright (c) 2023 Challenge. All rights reserved.
//

import UIKit

import SnapKit

final class ChallengeViewController: UIViewController {
    
    private lazy var navigationBar = LHNavigationBarView(type: .challenge, viewController: self)
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "동현이는슈퍼맨아빠님,"
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.gray200)
        label.textAlignment = .center
        return label
    }()
    
    private let challengeDayLabel: UILabel = {
        let label = UILabel()
        label.text = "23일째 도전 중"
        label.font = .pretendard(.head3)
        label.textColor = .designSystem(.white)
        label.textAlignment = .center
        return label
    }()
    
    private let levelBadge: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = .assetImage(.img_levelBadge)
        return imageView
    }()
    
    private let challengelevelLabel: UILabel = {
        let label = UILabel()
        label.text = "사자력 Lv.1"
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.gray500)
        label.textAlignment = .center
        
        let attributtedString = NSMutableAttributedString(string: label.text!)
        attributtedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.designSystem(.white), range: (label.text! as NSString).range(of:"Lv.1"))
        label.attributedText = attributtedString
        return label
    }()
    
    private let leftLine: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = .assetImage(.leftline)
        return imageView
    }()
    
    private let rightLine: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = .assetImage(.rightLine)
        return imageView
    }()
    
    private let levelBar: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = .assetImage(.img_levelBar)
        return imageView
    }()
    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        setHierarchy()
        setLayout()
        setNavigationBar()

    }
}

private extension ChallengeViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
            nicknameLabel, challengeDayLabel, leftLine, rightLine, levelBadge, levelBar)
        levelBadge.addSubview(challengelevelLabel)
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setLayout() {
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.bottom.equalTo(challengeDayLabel.snp.top)
            make.centerX.equalToSuperview()
        }
        challengeDayLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        leftLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            make.trailing.equalTo(challengeDayLabel.snp.leading).offset(-8)
        }
        rightLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            make.leading.equalTo(challengeDayLabel.snp.trailing).offset(8)
        }
        levelBadge.snp.makeConstraints { make in
            make.top.equalTo(challengeDayLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        challengelevelLabel.snp.makeConstraints { make in
            make.top.equalTo(levelBadge.snp.top).inset(16)
            make.centerX.equalToSuperview()
        }
        levelBar.snp.makeConstraints { make in
            make.top.equalTo(levelBadge.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
//            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(458)
        }
    }
    
}
