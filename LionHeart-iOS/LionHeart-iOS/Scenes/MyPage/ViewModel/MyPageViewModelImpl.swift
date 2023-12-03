//
//  MyPageViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/20.
//

import Foundation
import Combine

final class MyPageViewModelImpl: MyPageViewModel, MyPageViewModelPresentable {
    
    enum FlowType { case backButtonTapped, resignButtonTapped }
    
    private let navigator: MyPageNavigation
    private let manager: MyPageManager
    private var cancelBag = Set<AnyCancellable>()
    let navigationSubject = PassthroughSubject<FlowType, Never>()
    let errorSubject = PassthroughSubject<NetworkError, Never>()
    
    init(navigator: MyPageNavigation, manager: MyPageManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    func transform(input: MyPageViewModelInput) -> MyPageViewModelOutput {
        let viewWillAppearSubject = input.viewWillAppearSubject
            .flatMap { _ -> AnyPublisher<MyPageModel, Never> in
                return Future<MyPageModel, NetworkError> { promise in
                    Task {
                        do {
                            let data = try await self.manager.getMyPage()
                            let model = MyPageModel(profileData: data, appSettingData: MyPageRow.appSettingService, customerServiceData: MyPageRow.customSerive)
                            promise(.success(model))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just(MyPageModel.empty)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        input.backButtonTapped
            .sink { [weak self] in
                self?.navigationSubject.send(.backButtonTapped)
            }
            .store(in: &cancelBag)
        
        input.resignButtonTapped
            .flatMap { _ -> AnyPublisher<Void, Never> in
                return Future<Void, NetworkError> { promise in
                    Task {
                        do {
                            try await self.manager.resignUser()
                            promise(.success(()))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just(())
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            .sink { [weak self] _ in
                self?.navigationSubject.send(.resignButtonTapped)
            }
            .store(in: &cancelBag)

        
        errorSubject
            .sink { print($0) }
            .store(in: &cancelBag)
         
        self.navigationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
                case .backButtonTapped:
                    self?.navigator.backButtonTapped()
                case .resignButtonTapped:
                    self?.navigator.checkTokenIsExpired()
                }
            }
            .store(in: &cancelBag)
        
        return MyPageViewModelOutput(viewWillAppearSubject: viewWillAppearSubject)
    }
}
