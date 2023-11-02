//
//  LoginViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/2/23.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

/*
 1. LoginUseCase: ViewController가 ViewModel이 해줬으면 하는 작업들의 추상화
 2. LoginViewModelHandler: Factory가 ViewModel 객체를 만들 때, Factory를 가지고 있는 Coordinator가 리턴으로 실제 객체 타입을 바라보지 않게끔 하기 위한 추상화
 3. ViewModel: ViewModel 구조 자체에 대한 추상화
 */

typealias LoginViewModel = LoginUseCase & ViewModel

final class LoginViewModelImpl: LoginViewModel, LoginViewModelHandler  {
    
//    private let articleId: Int
//    
//    func setAricleId(_ id: Int) {
//        <#code#>
//    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    var navigator: LoginNavigation

    private let manager: LoginManager
    
    init(navigator: LoginNavigation, manager: LoginManager) {
        self.navigator = navigator
        self.manager = manager
        
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
//    
//    private func loginKakaoWithApp() {
//        UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
//            guard error == nil else {
//                LHToast.show(message: "카카오api에러 151")
//                return
//                
//            }
//            print("Login with KAKAO App Success !!")
//            guard let oAuthToken = oAuthToken else {
//                LHToast.show(message: "카카오api에러 157")
//                return
//                
//            }
//            print(oAuthToken.accessToken)
//            self.kakaoAccessToken = oAuthToken.accessToken
//        }
//    }
//
//    private func loginKakaoWithWeb() {
//        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
//            guard error == nil else {
//                LHToast.show(message: "카카오api에러 164")
//                return
//                
//            }
//            print("Login with KAKAO Web Success !!")
//            guard let oAuthToken = oAuthToken else {
//                LHToast.show(message: "카카오api에러 175")
//                return
//                
//            }
//            print(oAuthToken.accessToken)
//            self.kakaoAccessToken = oAuthToken.accessToken
//        }
//    }
}


// MARK: - Network

extension LoginViewModelImpl: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        LHToast.show(message: error.description)
        switch error {
        case .clientError(let code, let message):
            print(code, message)
            if code == NetworkErrorCode.unfoundUserErrorCode {
                LHToast.show(message: "코드 잘돌아감")
                self.navigator.checkUserIsVerified(userState: .nonVerified, kakaoToken: kakaoAccessToken)
            }
        default:
            LHToast.show(message: error.description)
        }
    }
}

extension LoginViewController {
    private func loginAPI(kakaoToken: String) {
        Task {
            do {
                try await manager.login(type: .kakao, kakaoToken: kakaoToken)
                self.navigator.checkUserIsVerified(userState: .verified, kakaoToken: kakaoToken)
            } catch {
                guard let error = error as? NetworkError else {
                    LHToast.show(message: "넷웤에러 95")
                    return
                }
                handleError(error)
            }
        }
    }
}
