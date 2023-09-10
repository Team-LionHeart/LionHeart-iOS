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
            guard let kakaoToken = self.kakaoAccessToken else {
                LHToast.show(message: "카카오토큰 언래핑 실패 21")
                return
            }
            self.loginAPI(kakaoToken: kakaoToken)
        }
    }

    private let authService: AuthServiceProtocol
    
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

    init(authService: AuthServiceProtocol) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
}

// MARK: - Network

extension LoginViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        LHToast.show(message: error.description)
        switch error {
        case .clientError(let code, let message):
            print(code, message)
            if code == NetworkErrorCode.unfoundUserErrorCode {
                LHToast.show(message: "코드 잘돌아감")
                self.moveUserToOnboardingViewController()
            }
        default:
            LHToast.show(message: error.description)
        }
    }
}

extension LoginViewController {
    private func loginAPI(kakaoToken: String) {
        Task {
            do {
                try await authService.login(type: .kakao, kakaoToken: kakaoToken)
                guard let window = self.view.window else {
                    LHToast.show(message: "로그인api에서 window guard let 88")
                    return
                }
                let mainTabbarViewController = TabBarViewController()
                ViewControllerUtil.setRootViewController(window: window, viewController: mainTabbarViewController, withAnimation: false)
            } catch {
                guard let error = error as? NetworkError else {
                    LHToast.show(message: "넷웤에러 95")
                    return
                }
                handleError(error)
            }
        }
    }

    func moveUserToOnboardingViewController() {
        let onboardingViewController = OnboardingViewController(authService: AuthMyPageServiceWrapper(authAPIService: AuthAPI(apiService: APIService()), mypageAPIService: MyPageAPI(apiService: APIService())))
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
            guard error == nil else {
                LHToast.show(message: "카카오api에러 151")
                return
                
            }
            print("Login with KAKAO App Success !!")
            guard let oAuthToken = oAuthToken else {
                LHToast.show(message: "카카오api에러 157")
                return
                
            }
            print(oAuthToken.accessToken)
            self.kakaoAccessToken = oAuthToken.accessToken
        }
    }

    private func loginKakaoWithWeb() {
        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
            guard error == nil else {
                LHToast.show(message: "카카오api에러 164")
                return
                
            }
            print("Login with KAKAO Web Success !!")
            guard let oAuthToken = oAuthToken else {
                LHToast.show(message: "카카오api에러 175")
                return
                
            }
            print(oAuthToken.accessToken)
            self.kakaoAccessToken = oAuthToken.accessToken
        }
    }
}
