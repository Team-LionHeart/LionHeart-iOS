//
//  SplashViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Splash. All rights reserved.
//

import UIKit

import SnapKit
import Lottie

final class SplashViewController: UIViewController {

    // MARK: - UI Components

    private let lottieImageView: LottieAnimationView = {
        let view = LottieAnimationView(name: "motion_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()

    // MARK: - Properties

    private let authManager = AuthService.shared

    // MARK: - Life Cycle

    override func viewDidLoad() {

        super.viewDidLoad()
        UserDefaultsManager.tokenKey = Token(accessToken: "eyJhbGciOiJIUzUxMiJ9.eyJNRU1CRVJfSUQiOjMsImV4cCI6MTcyMDg5OTMwN30.1sflleOwtvac7GrjQBIRv_LcOr-JVavCY_H6C1ji7y9ove-84MkNynFXKTtL4TCDYsIR0gtbjnKZBYeXEDS2FQ", refreshToken: "eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE3MjA4OTkzMDd9.ZhIn1NVd2fzYjw4Bs9Drm8AHOzKRh2ovB0e7kWf6Y0Um1uyp54FcAVROcy1KadZB6B0kVE5RFXDfna6cNYbfVA")
        setUI()
        setHierarchy()
        setLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        lottieImageView.play()
        guard let token = self.checkTokenIsExist() else { return }
        Task {
            await self.refreshToken(token: token)
        }
    }

}

// MARK: - UI

private extension SplashViewController {

    func setUI() {
        view.backgroundColor = .designSystem(.black)
    }
    
    func setHierarchy() {
        view.addSubviews(lottieImageView)
    }
    
    func setLayout() {
        lottieImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }

    func setRootViewController(to viewController: UIViewController, animation: Bool) {
        guard let window = self.view.window else { return }
        ViewControllerUtil.setRootViewController(window: window, viewController: viewController, withAnimation: animation)
    }
}

// MARK: - Network

private extension SplashViewController {
    func checkTokenIsExist() -> Token? {
        guard let token = UserDefaultsManager.tokenKey else {
            return nil
        }
        return token
    }

    func refreshToken(token: Token) async {
        do {
            let token = try await authManager.refreshingToken(
                token: Token(accessToken: token.accessToken, refreshToken: token.refreshToken)
            )
            UserDefaultsManager.tokenKey = token
            let tabBar = TabBarViewController()
            setRootViewController(to: tabBar, animation: true)
        } catch {
            guard let errorModel = error as? NetworkError else { return }
            await handleError(errorModel)
        }
    }

    func logout(token: Token) async {
        do {
            try await authManager.logout(token: token)
        } catch {
            print(error)
        }
    }

    func handleError(_ error: NetworkError) async {
        switch error {
        case .clientError(let code, let message):
            if code == NetworkErrorCode.unauthorizedErrorCode {
                guard let token = UserDefaultsManager.tokenKey else { return }
                await logout(token: token)
                // LoginVC로 이동하기
                let loginVC = LoginViewController()
                setRootViewController(to: loginVC, animation: true)
            } else {
                print(code, message)
            }
        default:
            print(error)
        }
    }
}
