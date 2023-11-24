//
//  SplashViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/16/23.
//

import Foundation
import Combine


final class SplashViewModelImpl: SplashViewModel, SplashViewModelPresentable {
    
    private let navigator: SplashNavigation
    private let manager: SplashManager
    
    private let tokenNonExistSubject = PassthroughSubject<Void, Never>()
    private let logoutSubject = PassthroughSubject<Void, Never>()
    private let navigationSubject = PassthroughSubject<TokenState, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    init(navigator: SplashNavigation, manager: SplashManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    func transform(input: SplashViewModelInput) -> SplashViewModelOutput {
        
        navigationSubject
            .receive(on: RunLoop.main)
            .sink { state in
                switch state {
                case .expired:
                    self.navigator.checkToken(state: .expired)
                case .valid:
                    self.navigator.checkToken(state: .valid)
                }
            }
            .store(in: &cancelBag)
        
        let splashErrorMessage = input.lottiePlayFinished
            .map { [weak self] _ -> (String?, String?) in
                guard let accessToken = UserDefaultsManager.tokenKey?.accessToken,
                      let refreshToken = UserDefaultsManager.tokenKey?.refreshToken else {
                    self?.navigationSubject.send(.expired)
                    return (nil, nil)
                }
                return (accessToken, refreshToken)
            }
            .filter { (accessToken, refreshToken) in
                return accessToken != nil && refreshToken != nil
            }
            .flatMap { (accessToken, refreshToken) -> AnyPublisher<String, Never> in
                
                return Future<String, NetworkError> { _ in
                    Task {
                        do {
                            guard let accessToken = UserDefaultsManager.tokenKey?.accessToken,
                                  let refreshToken = UserDefaultsManager.tokenKey?.refreshToken else { return }
                            try await self.reissueToken(refreshToken: refreshToken, accessToken: accessToken)
                        } catch {
                            guard let errorModel = error as? NetworkError else { return }
                            await self.handleError(errorModel)
                        }
                    }
                }
                .catch { error in
                    return Just(error.description)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let logoutSubject = logoutSubject
            .flatMap { _ -> AnyPublisher<String, Never> in
                return Future<String, NetworkError> { promise in
                    Task {
                        do {
                            guard let token = UserDefaultsManager.tokenKey else { return }
                            try await self.logout(token: token)
                            self.navigationSubject.send(.expired)
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }.catch { error in
                    return Just(error.description)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        
        let mergeSubject = splashErrorMessage
            .merge(with: logoutSubject)
            .eraseToAnyPublisher()
        
        return SplashViewModelOutput(splashNetworkErrorMessage: mergeSubject)
    }
    
}

private extension SplashViewModelImpl {

    func reissueToken(refreshToken: String, accessToken: String) async throws {
        let dtoToken = try await manager.reissueToken(token: Token(accessToken: accessToken, refreshToken: refreshToken))
        UserDefaultsManager.tokenKey?.accessToken = dtoToken?.accessToken
        UserDefaultsManager.tokenKey?.refreshToken = dtoToken?.refreshToken
        self.navigationSubject.send(.valid)
    }

    func handleError(_ error: NetworkError) async {
        switch error {
        case .clientError(let code, _):
            if code == NetworkErrorCode.unauthorizedErrorCode {
                logoutSubject.send(())
            } else if code == NetworkErrorCode.unfoundUserErrorCode {
                self.navigationSubject.send(.expired)
            }
        default: break
        }
    }
    
    func logout(token: UserDefaultToken) async throws {
        try await manager.logout(token: token)
    }
}
