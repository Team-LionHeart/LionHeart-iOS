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
//    var userData: UserOnboardingModel?
    
    //    var navigator: LoginNavigation
    //
    //    private let manager: LoginManager
    
//    private var kakaoAccessToken: String? {
//        didSet {
//            guard let kakaoToken = self.kakaoAccessToken else {
//                LHToast.show(message: "카카오토큰 언래핑 실패 21")
//                return
//            }
//            self.loginAPI(kakaoToken: kakaoToken)
//        }
//    }
    
    // MARK: - Properties
    
    private let viewModel: LoginViewModel
    
    // MARK: - UI Components

    private let loginMainImageView = LHImageView(in: ImageLiterals.Login.loginBackgroundImage, contentMode: .scaleAspectFill)

    private let mainLogoImageView = LHImageView(in: UIImage(named: "temporary_splash_image"), contentMode: .scaleAspectFit)

    private let mainLabel = LHLabel(type: .title2, color: .gray400, basicText: "하루 10분, 좋은 아빠가 되는 방법")

    private let kakakoLoginButton = LHImageButton(setImage: ImageLiterals.Login.kakaoLogo)
        .setTitle(font: .subHead2, text: "카카오로 로그인하기", color: .black)
        .setCornerRadius(for: 4)
        .setMarginImageWithText(for: 8)
        .setBackgroundColor(color: .kakao)

    // MARK: - LifeCycle
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
}
