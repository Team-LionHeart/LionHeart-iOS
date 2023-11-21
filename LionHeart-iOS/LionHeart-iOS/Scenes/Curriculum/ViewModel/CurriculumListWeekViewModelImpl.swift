//
//  CurriculumListWeekViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/21/23.
//

import Foundation
import Combine


final class CurriculumListWeekViewModelImpl: CurriculumListWeekViewModel, CurriculumListWeekViewModelPresentable {
    private let manager: CurriculumListManager
    private let navigator: CurriculumListByWeekNavigation
    private enum FlowType { case backButtonTapped }
    private let navigationSubject = PassthroughSubject<FlowType, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    var weekCount: Int?
    
    var selectedIndexPath: IndexPath?
    var inputData: CurriculumWeekData?
    
    init(manager: CurriculumListManager, navigator: CurriculumListByWeekNavigation) {
        self.manager = manager
        self.navigator = navigator
        bind()
    }
    
    private func bind() {
        self.navigationSubject
            .sink { [weak self] in
                switch $0 {
                case .backButtonTapped:
                    self?.navigator.backButtonTapped()
                }
            }
            .store(in: &cancelBag)
    }
    
    func transform(input: CurriculumListWeekViewModelInput) -> CurriculumListWeekViewModelOutput {
        let viewWillAppearSubject = input.viewWillAppearSubject
            .flatMap { _ -> AnyPublisher<CurriculumWeekData, Never> in
                return Future<CurriculumWeekData, NetworkError> { promise in
                    Task {
                        do {
                            guard let weekCount = self.weekCount else { return }
                            let articlesByWeek = try await self.manager.getArticleListByWeekInfo(week: weekCount)
                            promise(.success(articlesByWeek))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    print(error.description)
                    return Just(CurriculumWeekData(articleData: [], week: 1))
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        input.backButtonTapped
            .sink { [weak self] in self?.navigationSubject.send(.backButtonTapped) }
            .store(in: &cancelBag)

        return CurriculumListWeekViewModelOutput(articleByWeekData: viewWillAppearSubject)
    }
    
    
    
    func setWeek(week: Int) {
        self.weekCount = week
    }
}

