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
            guard let fatalNickName = userData?.fatalNickname else { return }
            self.titleLabel.text = "\(fatalNickName)님\n반가워요!"
        }
    }
    
    private let welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .designSystem(.white)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .pretendard(.head2)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "아티클 맞춤 환경이 준비되었어요."
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray400)
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.font = .pretendard(.subHead2)
        button.setTitleColor(.designSystem(.white), for: .normal)
        button.backgroundColor = .designSystem(.lionRed)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - autolayout설정
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
