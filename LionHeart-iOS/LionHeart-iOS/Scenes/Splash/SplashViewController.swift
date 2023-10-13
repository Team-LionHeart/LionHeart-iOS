//
//  SplashViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Splash. All rights reserved.
//

import UIKit

import SnapKit


enum TokenState {
    case valid
    case expired
}

protocol SplashManager {
    func reissueToken(token: Token) async throws -> Token?
    func logout(token: UserDefaultToken) async throws
}

protocol SplashNavigation: AnyObject {
    func checkToken(state: TokenState)
}

final class SplashViewController: UIViewController {

    // MARK: - UI Components

    private let lottieImageView = LHLottie(name: "motion_logo_final")

    // MARK: - Properties
    
    weak var coordinator: SplashNavigation?
    private let manager: SplashManager

    // MARK: - Life Cycle

    init(manager: SplashManager) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        lottieImageView.play { _ in
            guard let accessToken = UserDefaultsManager.tokenKey?.accessToken, let refreshToken = UserDefaultsManager.tokenKey?.refreshToken else {
//                let loginViewController = UINavigationController(rootViewController: LoginViewController(manager: LoginMangerImpl(authService: AuthServiceImpl(apiService: APIService()))))
//                guard let window = self.view.window else { return }
//                ViewControllerUtil.setRootViewController(window: window, viewController: loginViewController, withAnimation: true)
                self.coordinator?.checkToken(state: .expired)
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
            make.top.equalToSuperview().inset(200)
            make.centerX.equalToSuperview()
            make.size.equalTo(220)
        }
    }

//    func setRootViewController(to viewController: UIViewController, animation: Bool) {
//        guard let window = self.view.window else { return }
//        ViewControllerUtil.setRootViewController(window: window, viewController: viewController, withAnimation: animation)
//    }
}

// MARK: - Network

private extension SplashViewController {

    func reissueToken(refreshToken: String, accessToken: String) async throws {
        do {
            let dtoToken = try await manager.reissueToken(token: Token(accessToken: accessToken, refreshToken: refreshToken))
            UserDefaultsManager.tokenKey?.accessToken = dtoToken?.accessToken
            UserDefaultsManager.tokenKey?.refreshToken = dtoToken?.refreshToken
//
//            let tabBar = TabBarViewController()
//            setRootViewController(to: tabBar, animation: true)
            
            self.coordinator?.checkToken(state: .valid)
        } catch {
            guard let errorModel = error as? NetworkError else { return }
            await handleError(errorModel)
        }
    }

    func logout(token: UserDefaultToken) async {
        do {
            try await manager.logout(token: token)
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
//                let loginVC = UINavigationController(rootViewController: LoginViewController(manager: LoginMangerImpl(authService: AuthServiceImpl(apiService: APIService()))))
//                setRootViewController(to: loginVC, animation: true)
                
                self.coordinator?.checkToken(state: .expired)
            } else if code == NetworkErrorCode.unfoundUserErrorCode {
//                let loginVC = UINavigationController(rootViewController: LoginViewController(manager: LoginMangerImpl(authService: AuthServiceImpl(apiService: APIService()))))
//                setRootViewController(to: loginVC, animation: true)
                
                self.coordinator?.checkToken(state: .expired)
            }
        default:
            print(error)
        }
    }
}
