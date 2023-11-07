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

/*
 1. LoginUseCase: ViewController가 ViewModel이 해줬으면 하는 작업들의 추상화
 2. LoginViewModelHandler: Factory가 ViewModel 객체를 만들 때, Factory를 가지고 있는 Coordinator가 리턴으로 실제 객체 타입을 바라보지 않게끔 하기 위한 추상화
 3. ViewModel: ViewModel 구조 자체에 대한 추상화
 4. LoginViewModel: Input output에 대한 추상화
 */


final class LoginViewModelImpl:  LoginViewModel, LoginUseCase, LoginViewModelHandler {
    var navigator: LoginNavigation
    private var token: String?
    private let manager: LoginManager
    private let errorStream: PassthroughSubject<String, Never> = PassthroughSubject()
    
    init(navigator: LoginNavigation, manager: LoginManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    
    func transform(input: Input) -> Output {
        
        let loginSuccess = input.kakakoLoginButtonTap
            .map { _ -> Future<String, NetworkError> in
                return Future { promise in
                    Task {
                        do {
                            if UserApi.isKakaoTalkLoginAvailable() {
                                let token = try await self.loginKakaoWithApp()
                                self.token = token
                                try await self.loginAPI(kakaoToken: token)
                                self.errorStream.send("로그인성공")
                            } else {
                                let token = try await self.loginKakaoWithWeb()
                                self.token = token
                                try await self.loginAPI(kakaoToken: token)
                                self.errorStream.send("로그인성공")
                            }
                        } catch {
                            let networkError = error as! NetworkError
                            self.handleError(networkError)
                            self.errorStream.send("가입되지않은사람이라 온보딩으로갑니다")
                        }
                    }
                }
            }
            .eraseToAnyPublisher()
            return Output(loginSuccess: loginSuccess, errorStream: errorStream)
    }
    
    private func loginKakaoWithApp() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
                guard error == nil else {
                    self.errorStream.send("카카오에러")
                    return
                }
                guard let oAuthToken = oAuthToken else {
                    self.errorStream.send("카카오에러")
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
                        self.errorStream.send("카카오에러")
                        return
                    }
                    guard let oAuthToken = oAuthToken else {
                        self.errorStream.send("카카오에러")
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
        switch error {
        case .clientError(let code, let message):
            print(code, message)
            if code == NetworkErrorCode.unfoundUserErrorCode {
                DispatchQueue.main.async {
                    self.navigator.checkUserIsVerified(userState: .nonVerified, kakaoToken: self.token)
                }
            }
        default:
            errorStream.send("알수없는에러")
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
