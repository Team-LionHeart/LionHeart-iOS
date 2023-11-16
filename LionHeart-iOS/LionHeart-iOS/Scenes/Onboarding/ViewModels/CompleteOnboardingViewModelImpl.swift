//
//  CompleteOnboardingViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/11/16.
//

import Foundation
import Combine

final class CompleteOnboardingViewModelImpl: CompleteOnboardingViewModel {
    
    private var userData: UserOnboardingModel?
    private var navigator: CompleteOnboardingNavigation
    private var navigatorSubject = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    init(navigator: CompleteOnboardingNavigation) {
        self.navigator = navigator
    }
    
    func transform(input: CompleteOnboardingViewModelInput) -> CompleteOnboardingViewModelOutput {
        
        navigatorSubject
            .receive(on: RunLoop.main)
            .sink { _ in
                self.navigator.startButtonTapped()
            }
            .store(in: &cancelBag)
        
        let fetalNickname = input.viewWillAppear
            .map { _ in
                return self.userData?.fetalNickname
            }
            .eraseToAnyPublisher()
        
        input.startButtonTapped
            .sink { _ in
                self.navigatorSubject.send(())
            }
            .store(in: &cancelBag)
        
        return CompleteOnboardingViewModelOutput(fetalNickname: fetalNickname)
    }
}

extension CompleteOnboardingViewModelImpl: CompleteOnboardingViewModelPresentable {
    func setUserData(_ userData: UserOnboardingModel) {
        self.userData = userData
    }
}
