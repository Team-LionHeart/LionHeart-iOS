//
//  OnboardingViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/15.
//

import Foundation
import Combine

final class OnboardingViewModelImpl: OnboardingViewModel {
    
    private enum FlowType {
        case onboardingCompleted(UserOnboardingModel)
        case backButtonTapped
    }
    
    private var navigator: OnboardingNavigation
    private let manager: OnboardingManager
    private var kakaoAccessToken: String?
    private let signUpSubject = PassthroughSubject<Void, Never>()
    private var navigatorSubject = PassthroughSubject<FlowType, Never>()
    private var userSigningSubject = PassthroughSubject<Bool, Never>()
    private var cancelBag = Set<AnyCancellable>()
    private var currentPage: OnboardingPageType = .getPregnancy
    private var onboardingFlow: OnbardingFlowType = .toGetPregnacny
    
    init(navigator: OnboardingNavigation, manager: OnboardingManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    func transform(input: OnboardingViewModelInput) -> OnboardingViewModelOutput {
        
        let userSigningSubject = userSigningSubject
            .map { $0 }
            .eraseToAnyPublisher()
        
        navigatorSubject
            .receive(on: RunLoop.main)
            .sink { type in
                switch type {
                case .backButtonTapped:
                    self.navigator.backButtonTapped()
                case .onboardingCompleted(let data):
                    self.navigator.onboardingCompleted(data: data)
                }
            }
            .store(in: &cancelBag)
        
        let fetalButtonState = input.fetalNickname
            .map { $0.isValid }
            .eraseToAnyPublisher()
        
        let pregenacyButtonState = input.pregenacy
            .map { $0.isValid }
            .eraseToAnyPublisher()
        
        let onboardingFlow = input.nextButtonTapped
            .map { _ in
                if self.onboardingFlow == .toFetalNickname {
                    self.signUpSubject.send(())
                }
                self.onboardingFlow = OnbardingFlowType.toFetalNickname
                return self.onboardingFlow
            }
            .eraseToAnyPublisher()
        
        let signUpSubject = signUpSubject
            .flatMap { _ -> AnyPublisher<String, Never> in
                return Future<String, NetworkError> { promise  in
                    Task {
                        do {
                            self.userSigningSubject.send(false)
                            let passingData = UserOnboardingModel(kakaoAccessToken: self.kakaoAccessToken, pregnacny: input.pregenacy.value.pregnancy, fetalNickname: input.fetalNickname.value.fetalNickname)
                            try await self.manager.signUp(type: .kakao, onboardingModel: passingData)
                            self.userSigningSubject.send(true)
                            self.navigatorSubject.send(.onboardingCompleted(passingData))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    Just(error.description)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        input.backButtonTapped
            .sink { [weak self] in
                self?.navigatorSubject.send(.backButtonTapped)
            }
            .store(in: &cancelBag)
        
        return OnboardingViewModelOutput(pregenacyButtonState: pregenacyButtonState, fetalButtonState: fetalButtonState, onboardingFlow: onboardingFlow, signUpSubject: signUpSubject, userSigningSubject: userSigningSubject)
    }
}

extension OnboardingViewModelImpl: OnboardingViewModelPresentable {
    func setKakaoAccessToken(_ token: String?) {
        self.kakaoAccessToken = token
    }
}
