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
    
//    private let articleId: Int
//    
//    func setAricleId(_ id: Int) {
//        <#code#>
//    }
    var navigator: LoginNavigation

    private let manager: LoginManager
    
    init(navigator: LoginNavigation, manager: LoginManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    func transform(input: Input) -> Output {
        let loginSuccess = input.kakakoLoginButtonTap
            .errorTask { _ in
                do {
                    if UserApi.isKakaoTalkLoginAvailable() {
                        return try await self.loginKakaoWithApp()
                    } else {
                        return try await self.loginKakaoWithWeb()
                    }
                } catch NetworkError.unAuthorizedError {
                    // 앱 종료
                    // coordinator
                }
            }
            .errorTask { str in
                
                
                
                
                return try await self.loginAPI(kakaoToken: str)
            }
            .eraseToAnyPublisher()
        
        
        return Output(loginSuccess: loginSuccess)
    }
    
//    var userData: UserOnboardingModel?
    
//    private var kakaoAccessToken: String? {
//        didSet {
//            guard let kakaoToken = self.kakaoAccessToken else {
//                LHToast.show(message: "카카오토큰 언래핑 실패 21")
//                return
//            }
//            self.loginAPI(kakaoToken: kakaoToken)
//        }
//    }
    
    
    
    
    private func loginKakaoWithApp() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
                guard error == nil else {
                    continuation.resume(throwing: NetworkError.unAuthorizedError)
                    return
                }
                
                guard let oAuthToken = oAuthToken else {
                    continuation.resume(throwing: NetworkError.unAuthorizedError)
                    return
                }

                continuation.resume(returning: oAuthToken.accessToken)
            }
        }
        
    }
    
    private func loginKakaoWithWeb() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
                guard error == nil else {
                    continuation.resume(throwing: NetworkError.unAuthorizedError)
                    return
                    
                }
                
                guard let oAuthToken = oAuthToken else {
                    continuation.resume(throwing: NetworkError.unAuthorizedError)
                    return
                }
                
                continuation.resume(returning: oAuthToken.accessToken)
            }
        }
    }
    
}


// MARK: - Network

//    func setAddTarget() {
//        // input으로 넘기기
//        kakakoLoginButton.addButtonAction { sender in
//            if UserApi.isKakaoTalkLoginAvailable() {
//                self.loginKakaoWithApp()
//            } else {
//                self.loginKakaoWithWeb()
//            }
//        }
//    }

extension LoginViewModelImpl {
    func handleError(_ error: NetworkError) {
        LHToast.show(message: error.description) // ViewController로 이동해야할 코드 (ViewModel은 UIKit을 import할 필요가 없다)
        switch error {
        case .clientError(let code, let message):
            print(code, message)
            if code == NetworkErrorCode.unfoundUserErrorCode {
                LHToast.show(message: "코드 잘돌아감")
//                self.navigator.checkUserIsVerified(userState: .nonVerified, kakaoToken: kakaoAccessToken)
            }
        default:
            LHToast.show(message: error.description)
        }
    }
}

extension LoginViewModelImpl {
    private func loginAPI(kakaoToken: String) async throws {
        try await manager.login(type: .kakao, kakaoToken: kakaoToken)
//        self.navigator.checkUserIsVerified(userState: .verified, kakaoToken: kakaoToken)
    }
}


// viewmodel <-> coordinator Input들어오면 그냥 보내주면 됨
// viewmodel <-> manager Input들어오면 그냥 보내주면 근데 error handling 처리는 생각해야함
// ViewController에서 처리하는 에러가 popup 밖에없어서 error message String만 보내주면 될듯
// 나머지 인증에러는 coordinator로 요청보내면 ViewModel선에서 정리가능.
