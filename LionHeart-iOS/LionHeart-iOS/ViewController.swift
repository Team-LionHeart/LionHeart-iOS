//
//  ViewController.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/05.
//


// MARK: - 지워도 되는 파일
import UIKit
import SnapKit

import KakaoSDKAuth
import KakaoSDKUser

class ViewController: UIViewController {
    
    private let testLable: UILabel = {
        let label = UILabel()
        label.text = "폰트테스트라벨입니다"
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.componentLionRed)
        return label
    }()

    // MARK: - 카카오 로그인 예시

    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오로그인하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let testView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .designSystem(.black)
        setLayout()
    }

    private func setLayout() {
        view.addSubview(kakaoLoginButton)
        kakaoLoginButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.addSubview(testLable)
        testLable.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(testView)
        testView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(50)
        }
        
    }

    @objc func kakaoLoginButtonTapped() {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginKakaoWithApp()
        } else {
            loginKakaoWithWeb()
        }

        LHToast.show(message: "토스트메세지입니다")

        let nextVC = OnboardingViewController(authService: AuthMyPageServiceWrapper())
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    private func loginKakaoWithApp() {
        UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
            guard error == nil else { return }
            print("Login with KAKAO App Success !!")
            guard let oAuthToken = oAuthToken else { return }
            print(oAuthToken.accessToken)
        }
    }

    private func loginKakaoWithWeb() {
        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
            guard error == nil else { return }
            print("Login with KAKAO Web Success !!")
            guard let oAuthToken = oAuthToken else { return }
            print(oAuthToken.accessToken)
        }
    }

}

