//
//  LoginViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Login. All rights reserved.
//

import UIKit

import SnapKit

final class LoginViewController: UIViewController {
    
    private let loginMainImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "loginImage"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let mainLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "temporary_splash_image"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "하루 10분, 좋은 아빠가 되는 방법"
        label.font = .pretendard(.title2)
        label.textColor = .designSystem(.gray400)
        return label
    }()
    
    private let kakakoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오로 로그인하기", for: .normal)
        button.titleLabel?.font = .pretendard(.subHead2)
        button.setTitleColor(.designSystem(.black), for: .normal)
        button.setImage(UIImage(named: "kakaoImage"), for: .normal)
        button.backgroundColor = .designSystem(.kakao)
        button.marginImageWithText(margin: 8)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
}

private extension LoginViewController {
    func setUI() {
        
    }
    
    func setHierarchy() {
        view.addSubviews(loginMainImageView, mainLogoImageView, mainLabel, kakakoLoginButton)
    }
    
    func setLayout() {
        loginMainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainLogoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.leading.trailing.equalToSuperview().inset(120)
            make.height.equalTo(70)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLogoImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        kakakoLoginButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60)
            make.leading.trailing.equalToSuperview().inset(29)
            make.height.equalTo(50)
        }
    }
    
    func setAddTarget() {
        kakakoLoginButton.addButtonAction { sender in
            let mainViewController = TabBarViewController()
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }
    }
}
