//
//  MyPageViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/20.
//

import Foundation
import Combine

final class MyPageViewModelImpl: MyPageViewModel, MyPageViewModelPresentable {
    
    private enum FlowType { case backButtonTapped, resignButtonTapped }
    
    private let navigator: MyPageNavigation
    private let manager: MyPageManager
    private var cancelBag = Set<AnyCancellable>()
    private let navigationSubject = PassthroughSubject<FlowType, Never>()
    
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
                    print(error)
                    return Just(MyPageModel(profileData: .empty, appSettingData: [], customerServiceData: []))
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
            .sink { [weak self] in
                self?.navigationSubject.send(.resignButtonTapped)
            }
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
    
//    func setUIFromNetworking() {
//        Task {
//            do {
//                let data = try await manager.getMyPage()
//                badgeProfileAppData = data
//                setTableViewHeader(data)
//            } catch {
//                guard let error = error as? NetworkError else { return }
//                handleError(error)
//            }
//        }
//    }
//
//    resignButton.addButtonAction { _ in
//        Task {
//            do {
//                self.resignButton.isUserInteractionEnabled = false
//                try await self.manager.resignUser()
//                self.adaptor.checkTokenIsExpired()
//            } catch {
//                print(error)
//            }
//        }
//    }
}
