//
//  SplashViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Splash. All rights reserved.
//

import UIKit

import SnapKit

protocol SplashManager {
    func reissueToken(token: Token) async throws -> Token?
    func logout(token: UserDefaultToken) async throws
}

final class SplashViewController: UIViewController {

    weak var coordinator: SplashNavigation?
    private let manager: SplashManager
    
    private let lottieImageView = LHLottie(name: "motion_logo_final")

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
                self.coordinator?.checkToken(state: .expired)
                return
            }
            Task {
                try? await self.reissueToken(refreshToken: refreshToken, accessToken: accessToken)
            }
        }

    }
    
    private func checkIsRefreshTokenExist() -> String? {
        return UserDefaultsManager.tokenKey?.refreshToken
    }
}

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
}

private extension SplashViewController {

    func reissueToken(refreshToken: String, accessToken: String) async throws {
        do {
            let dtoToken = try await manager.reissueToken(token: Token(accessToken: accessToken, refreshToken: refreshToken))
            UserDefaultsManager.tokenKey?.accessToken = dtoToken?.accessToken
            UserDefaultsManager.tokenKey?.refreshToken = dtoToken?.refreshToken
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
                self.coordinator?.checkToken(state: .expired)
            } else if code == NetworkErrorCode.unfoundUserErrorCode {
                self.coordinator?.checkToken(state: .expired)
            }
        default:
            print(error)
        }
    }
}
