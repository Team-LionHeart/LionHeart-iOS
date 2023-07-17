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
        setUI()
        setHierarchy()
        setLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        lottieImageView.play { _ in
            guard let accessToken = UserDefaultsManager.tokenKey?.accessToken, let refreshToken = UserDefaultsManager.tokenKey?.refreshToken else {
                let loginViewController = UINavigationController(rootViewController: LoginViewController())
                guard let window = self.view.window else { return }
                ViewControllerUtil.setRootViewController(window: window, viewController: loginViewController, withAnimation: true)
                return
            }
            /// nil이 아니면 == refresh토큰이 어떤상태인지는 모르겠으나 있긴하다
            Task {
                // 토큰을 refresh합니다.
                try? await self.reissueToken(refreshToken: refreshToken, accessToken: accessToken)
            }
        }

    }
    
    private func checkIsRefreshTokenExist() -> String? {
        return UserDefaultsManager.tokenKey?.refreshToken
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
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setRootViewController(to viewController: UIViewController, animation: Bool) {
        guard let window = self.view.window else { return }
        ViewControllerUtil.setRootViewController(window: window, viewController: viewController, withAnimation: animation)
    }
}

// MARK: - Network

private extension SplashViewController {

    func reissueToken(refreshToken: String, accessToken: String) async throws {
        do {
            let dtoToken = try await authManager.reissueToken(token: Token(accessToken: accessToken, refreshToken: refreshToken))
        
            UserDefaultsManager.tokenKey?.accessToken = dtoToken?.accessToken
            UserDefaultsManager.tokenKey?.refreshToken = dtoToken?.refreshToken
            
            let tabBar = TabBarViewController()
            setRootViewController(to: tabBar, animation: true)
        } catch {
            guard let errorModel = error as? NetworkError else { return }
            await handleError(errorModel)
        }
    }

    func logout(token: UserDefaultToken) async {
        do {
            try await authManager.logout(token: token)
        } catch {
            print(error)
        }
    }

    func handleError(_ error: NetworkError) async {
        switch error {
        case .clientError(let code, _):
            if code == NetworkErrorCode.unauthorizedErrorCode {
                guard let token = UserDefaultsManager.tokenKey else { return }
                await logout(token: token)
                // LoginVC로 이동하기
                let loginVC = LoginViewController()
                setRootViewController(to: loginVC, animation: true)
            } else if code == NetworkErrorCode.resignedErrorCode {
                let loginVC = LoginViewController()
                setRootViewController(to: loginVC, animation: true)
            }
        default:
            print(error)
        }
    }
}
