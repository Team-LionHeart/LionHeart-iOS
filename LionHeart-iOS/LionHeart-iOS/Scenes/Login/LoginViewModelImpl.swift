//
//  LoginViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/2/23.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import Combine


final class LoginViewModelImpl: LoginViewModel, LoginViewModelPresentable {
    var navigator: LoginNavigation
    private var token: String?
    private let manager: LoginManager
    
    init(navigator: LoginNavigation, manager: LoginManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    func transform(input: Input) -> Output {
        let loginSuccess = input.kakakoLoginButtonTap
            .flatMap { _ -> AnyPublisher<String, Never> in
                return Future<String, NetworkError> { promise in
                    Task {
                        do {
                            let token = try await self.loginKakaoWithWeb()
                            self.token = token
                            try await self.loginAPI(kakaoToken: token)
                            promise(.success(token))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.handleError(error)
                    return Just(error.description)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
            return Output(loginSuccess: loginSuccess)
    }
    
    private func loginKakaoWithApp() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
                guard error == nil else {
                    continuation.resume(throwing: NetworkError.serverError)
                    return
                }
                guard let oAuthToken = oAuthToken else {
                    continuation.resume(throwing: NetworkError.serverError)
                    return
                }
                continuation.resume(returning: oAuthToken.accessToken)
            }
        }
    }
    
    private func loginKakaoWithWeb() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
                    guard error == nil else {
                        continuation.resume(throwing: NetworkError.serverError)
                        return
                    }
                    guard let oAuthToken = oAuthToken else {
                        continuation.resume(throwing: NetworkError.serverError)
                        return
                    }
                    continuation.resume(returning: oAuthToken.accessToken)
                }
            }
        }
    }
}

extension LoginViewModelImpl {
    func handleError(_ error: NetworkError) {
        if case .clientError(let code, _) = error {
            if code == NetworkErrorCode.unfoundUserErrorCode {
                DispatchQueue.main.async {
                    self.navigator.checkUserIsVerified(userState: .nonVerified, kakaoToken: self.token)
                }
            }
        }
    }
}

extension LoginViewModelImpl {
    private func loginAPI(kakaoToken: String) async throws {
        try await manager.login(type: .kakao, kakaoToken: kakaoToken)
        DispatchQueue.main.async {
            self.navigator.checkUserIsVerified(userState: .verified, kakaoToken: kakaoToken)
        }
    }
}


// viewmodel <-> coordinator Input들어오면 그냥 보내주면 됨
// viewmodel <-> manager Input들어오면 그냥 보내주면 근데 error handling 처리는 생각해야함
// ViewController에서 처리하는 에러가 popup 밖에없어서 error message String만 보내주면 될듯
// 나머지 인증에러는 coordinator로 요청보내면 ViewModel선에서 정리가능.
