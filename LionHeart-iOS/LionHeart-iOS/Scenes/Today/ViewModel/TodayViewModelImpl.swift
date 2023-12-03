//
//  TodayViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/19.
//

import Foundation
import Combine

final class TodayViewModelImpl: TodayViewModel, TodayViewModelPresentable {
    
    enum FlowType: Equatable { 
        case bookmarkButtonTapped
        case myPageButtonTapped
        case articleTapped(articleId: Int)
    }
    
    private let navigator: TodayNavigation
    private let manager: TodayManager
    
    let navigationSubject = PassthroughSubject<FlowType, Never>()
    let errorSubject = PassthroughSubject<NetworkError, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    var articleID: Int?
    
    init(navigator: TodayNavigation, manager: TodayManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    func transform(input: TodayViewModelInput) -> TodayViewModelOutput {
        
        self.errorSubject
            .sink { 
                print($0)
            }
            .store(in: &cancelBag)
        
        self.navigationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                switch $0 {
                case .bookmarkButtonTapped:
                    self.navigator.navigationLeftButtonTapped()
                case .myPageButtonTapped:
                    self.navigator.navigationRightButtonTapped()
                case .articleTapped(let articleId):
                    self.navigator.todayArticleTapped(articleID: articleId)
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
                guard let articleID = self?.articleID else { 
                    return
                }
                self?.navigationSubject.send(.articleTapped(articleId: articleID))
            }
            .store(in: &cancelBag)

        
        let viewWillAppearSubject = input.viewWillAppearSubject
            .flatMap { _ -> AnyPublisher<TodayArticle, Never> in
                return Future<TodayArticle, NetworkError> { promise in
                    Task {
                        do {
                            let responseArticle = try await self.manager.inquiryTodayArticle()
                            self.articleID = responseArticle.aticleID
                            promise(.success(responseArticle))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just(TodayArticle.emptyArticle)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        
        return TodayViewModelOutput(viewWillAppearSubject: viewWillAppearSubject)
    }
    

}
