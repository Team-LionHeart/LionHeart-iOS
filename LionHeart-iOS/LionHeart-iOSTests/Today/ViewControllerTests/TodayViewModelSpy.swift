//
//  TodayViewModelSpy.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 11/30/23.
//

import Foundation
import Combine

@testable import LionHeart_iOS

final class TodayViewModelSpy: TodayViewModel {
    private enum FlowType { case bookmarkButtonTapped, myPageButtonTapped }
    
    var todayArticle: TodayArticle?
    
    private let navigator: TodayNavigation
    private let manager: TodayManager
    
    private let navigationSubject = PassthroughSubject<FlowType, Never>()
    private var cancelBag = Set<AnyCancellable>()
    private var articleID: Int?
    
    init(navigator: TodayNavigation, manager: TodayManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    func transform(input: TodayViewModelInput) -> TodayViewModelOutput {
        
        self.navigationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
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
        
        input.todayArticleTapped
            .sink { [weak self] in
                guard let articleID = self?.articleID else { return }
                self?.navigator.todayArticleTapped(articleID: articleID)
            }
            .store(in: &cancelBag)

        
        let viewWillAppearSubject = input.viewWillAppearSubject
            .flatMap { _ -> AnyPublisher<TodayArticle, Never> in
                return Future<TodayArticle, NetworkError> { promise in
                    Task {
                        do {
                            let responseArticle = try await self.manager.inquiryTodayArticle()
                            self.todayArticle = responseArticle
                            self.articleID = responseArticle.aticleID
                            promise(.success(responseArticle))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    Just(TodayArticle.emptyArticle)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        
        return TodayViewModelOutput(viewWillAppearSubject: viewWillAppearSubject)
    }
}
