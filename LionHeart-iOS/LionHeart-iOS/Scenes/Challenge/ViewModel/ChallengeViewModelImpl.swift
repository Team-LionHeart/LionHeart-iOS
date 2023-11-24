//
//  ChallengeViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/18.
//

import Foundation
import Combine

final class ChallengeViewModelImpl: ChallengeViewModel, ChallengeViewModelPresentable {
    
    private enum FlowType { case bookmarkButtonTapped, myPageButtonTapped }
    
    private let navigationSubject = PassthroughSubject<FlowType, Never>()
    private var cancelBag = Set<AnyCancellable>()
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    
    private var navigator: ChallengeNavigation
    private var manager: ChallengeManager
    
    init(navigator: ChallengeNavigation, manager: ChallengeManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    
    func transform(input: ChallengeViewModelInput) -> ChallengeViewModelOutput {
        
        errorSubject
            .sink { print($0) }
            .store(in: &self.cancelBag)
        
        navigationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] flow in
                switch flow {
                case .bookmarkButtonTapped:
                    self?.navigator.navigationLeftButtonTapped()
                case .myPageButtonTapped:
                    self?.navigator.navigationRightButtonTapped()
                }
            }
            .store(in: &cancelBag)
        
        input.navigationLeftButtonTapped
            .sink { [weak self] in self?.navigationSubject.send(.bookmarkButtonTapped) }
            .store(in: &cancelBag)
        
        input.navigationRightButtonTapped
            .sink { [weak self] in self?.navigationSubject.send(.myPageButtonTapped) }
            .store(in: &cancelBag)
        
        let viewWillAppearSubject = input.viewWillAppearSubject
            .flatMap { _ -> AnyPublisher<ChallengeData, Never> in
                return Future<ChallengeData, NetworkError> { promise in
                    Task {
                        do {
                            let inputData = try await self.manager.inquireChallengeInfo()
                            promise(.success(inputData))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just(ChallengeData.empty)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return ChallengeViewModelOutput(viewWillAppearSubject: viewWillAppearSubject)
    }
}
