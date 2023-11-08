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

final class LoginViewModelImpl: LoginViewModel, LoginUseCase, LoginViewModelHandler {
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
        /// upstream이 PassthroughSubject<Void, Never>
        /// completion이 불리면 publiser와 subscriber의 steam이 끊김
        /// never를 통해서 stream이 끊기지않게
        ///
        /// upstream의 error가 never면 flatmap의 return이 애초에 upstream이랑 아무상관이없어짐
        /// upstream의 error가 never가 아니면 flatmap의 return이 upstream의 output이랑 failure type이 동일해야함
    
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
                    /// catch로 들어오면 completion이 불림
                    /// flatmap과 future가 끊어짐
                    /// 사실 flatmap이랑은 계속 연결되어있으니
                    /// 버튼이 눌리면 flapmap입장에서는 subscrber가 있으니가 계속 future를 생성해준다
                    self.handleError(error)
                    return Just("문제가 발생했어요")
                }
                .eraseToAnyPublisher()
            }
        
//            .catch { error in
//                self.handleError(error)
//                // 이러면 에러가 발생함
//                // Instance method 'catch' requires the types 'String' and 'NetworkError' be equivale
//                return Just(error)
//                // 이게 왜그러냐면 catch는 error를 받아서 publisher를 발행해주는 녀석인데
//                // 애초에 flatmap을 통해 만들어진 publiser는 string값을 stream에 보내주기때문에 catch도 stream에 string을 보내줘야함
//                return Just("dddddd")
//            }
            .eraseToAnyPublisher()
            return Output(loginSuccess: loginSuccess)
    }
    
    private func loginKakaoWithApp() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
                guard error != nil else {
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
                    guard error != nil else {
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
