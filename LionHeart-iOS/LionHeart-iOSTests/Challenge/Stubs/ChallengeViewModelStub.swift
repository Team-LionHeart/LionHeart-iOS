//
//  ChallengeViewModelStub.swift
//  LionHeart-iOSTests
//
//  Created by uiskim on 2023/12/01.
//

import Foundation
import Combine
@testable import LionHeart_iOS

final class ChallengeViewModelStub: ChallengeViewModel {
    
    enum FlowType { case bookmarkButtonTapped, myPageButtonTapped }
    
    var navigationSubject = PassthroughSubject<FlowType, Never>()
    private var cancelBag = Set<AnyCancellable>()
    let errorSubject = PassthroughSubject<NetworkError, Never>()
    var willPublishedData: ChallengeData?
    
    var inputData: ChallengeData!
    
    func transform(input: ChallengeViewModelInput) -> ChallengeViewModelOutput {
        
        input.navigationLeftButtonTapped
            .sink { [weak self] in
                self?.navigationSubject.send(.bookmarkButtonTapped)
            }
            .store(in: &cancelBag)
        
        input.navigationRightButtonTapped
            .sink {
                [weak self] in self?.navigationSubject.send(.myPageButtonTapped)
            }
            .store(in: &cancelBag)
        
        let viewWillAppearSubject = input.viewWillAppearSubject
            .flatMap { _ -> AnyPublisher<ChallengeData, Never> in
                self.willPublishedData = self.inputData
                return Just(self.inputData)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return ChallengeViewModelOutput(viewWillAppearSubject: viewWillAppearSubject)
    }
}
