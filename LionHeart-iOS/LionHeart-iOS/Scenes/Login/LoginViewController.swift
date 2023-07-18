//
//  LoginViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Login. All rights reserved.
//

import UIKit

import SnapKit

import KakaoSDKAuth
import KakaoSDKUser

final class LoginViewController: UIViewController {
    
    private var kakaoAccessToken: String? {
        didSet {
            guard let isExistAndExpired = UserDefaultsManager.tokenKey?.isExistJWT else { return }
            isExistAndExpired ? moveUserToTabbarController() : moveUserToOnboardingViewController()
        }
    }
    
    private let loginMainImageView: UIImageView = {
        let imageView = UIImageView(image: ImageLiterals.Login.loginBackgroundImage)
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
        button.setImage(ImageLiterals.Login.kakaoLogo, for: .normal)
        button.backgroundColor = .designSystem(.kakao)
        button.marginImageWithText(margin: 8)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
}

private extension LoginViewController {
    func moveUserToTabbarController() {
        Task {
            do {
                try await AuthService.shared.login(type: .kakao)
                guard let window = self.view.window else { return }
                let mainTabbarViewController = TabBarViewController()
                ViewControllerUtil.setRootViewController(window: window, viewController: mainTabbarViewController, withAnimation: false)
            } catch {
                print(error)
            }
        }
    }
    
    func moveUserToOnboardingViewController() {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.setKakaoAccessToken(kakaoAccessToken)
        self.navigationController?.pushViewController(onboardingViewController, animated: true)
    }
}

private extension LoginViewController {
    
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
            if UserApi.isKakaoTalkLoginAvailable() {
                self.loginKakaoWithApp()
            } else {
                self.loginKakaoWithWeb()
            }
        }
    }
    
    private func loginKakaoWithApp() {
        UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
            guard error == nil else { return }
            print("Login with KAKAO App Success !!")
            guard let oAuthToken = oAuthToken else { return }
            print(oAuthToken.accessToken)
            self.kakaoAccessToken = oAuthToken.accessToken
        }
    }

    private func loginKakaoWithWeb() {
        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
            guard error == nil else { return }
            print("Login with KAKAO Web Success !!")
            guard let oAuthToken = oAuthToken else { return }
            print(oAuthToken.accessToken)
            self.kakaoAccessToken = oAuthToken.accessToken
        }
    }
}


