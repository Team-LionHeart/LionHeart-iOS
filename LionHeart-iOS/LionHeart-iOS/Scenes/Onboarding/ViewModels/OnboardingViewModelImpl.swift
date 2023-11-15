//
//  OnboardingViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/15.
//

import Foundation
import Combine

final class OnboardingViewModelImpl: OnboardingViewModel {
    
    private var navigator: OnboardingNavigation
    private let manager: OnboardingManager
    private var kakaoAccessToken: String?
    private let signUpSubject = PassthroughSubject<String, Never>()
    
    init(navigator: OnboardingNavigation, manager: OnboardingManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    private var cancelBag = Set<AnyCancellable>()
    private var currentPage: OnboardingPageType = .getPregnancy
    private var onboardingFlow: OnbardingFlowType = .toGetPregnacny
    
    func transform(input: OnboardingViewModelInput) -> OnboardingViewModelOutput {
        let fetalButtonState = input.fetalNickname
            .map { $0.isValid }
            .eraseToAnyPublisher()
        
        let pregenacyButtonState = input.pregenacy
            .map { $0.isValid }
            .eraseToAnyPublisher()
        
        let onboardingFlow = input.nextButtonTapped
            .map { _ in
                let oldValue = self.onboardingFlow
                self.onboardingFlow = self.currentPage.forward
                if self.onboardingFlow == .toCompleteOnboarding {
                    
                }
                return (oldValue: oldValue, newValue: self.onboardingFlow)
            }
            .eraseToAnyPublisher()
        
        input.backButtonTapped
            .sink { [weak self] in
                self?.navigator.backButtonTapped()
            }
            .store(in: &cancelBag)
        
        
        return OnboardingViewModelOutput(pregenacyButtonState: pregenacyButtonState, fetalButtonState: fetalButtonState, onboardingFlow: onboardingFlow, signUpSuccess: <#AnyPublisher<String, Never>#>)
    }
    
    func setKakaoAccessToken(_ token: String?) {
        self.kakaoAccessToken = token
    }

    func presentCompleteOnboardingView() {
        let passingData = UserOnboardingModel(kakaoAccessToken: self.kakaoAccessToken, pregnacny: self.pregnancy, fetalNickname: self.fetalNickName)
        Task {
            showLoading()
            do {
                try await manager.signUp(type: .kakao, onboardingModel: passingData)
                hideLoading()
                self.navigator.onboardingCompleted(data: passingData)
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }    
}
