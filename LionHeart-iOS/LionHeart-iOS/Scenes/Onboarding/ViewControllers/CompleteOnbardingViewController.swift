//
//  CompleteOnbardingViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//  Copyright (c) 2023 CompleteOnbarding. All rights reserved.
//

import UIKit

import SnapKit

final class CompleteOnbardingViewController: UIViewController {
    
    private enum SizeInspector {
        static let sideOffset: CGFloat = 58
    }
    
    var userData: UserOnboardingModel? {
        didSet {
            guard let fetalNickName = userData?.fetalNickname else { return }
            self.titleLabel.text = "\(fetalNickName)님\n반가워요!"
        }
    }
    
    private let titleLabel = LHOnboardingTitleLabel(nil, align: .center)
    private let descriptionLabel = LHOnboardingDescriptionLabel("아티클 맞춤 환경이 준비되었어요.")
    private let startButton = LHRoundButton(cornerRadius: 8, title: "시작하기")
    
    /// 추후 삭제할 component
    private let welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .designSystem(.white)
        return imageView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
    }
}

private extension CompleteOnbardingViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(welcomeImageView, titleLabel, descriptionLabel, startButton)
    }
    
    func setLayout() {
        welcomeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(180)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.Screen.width - (2*SizeInspector.sideOffset))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeImageView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(50)
        }
    }
}
