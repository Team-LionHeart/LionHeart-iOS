//
//  CurriculumListWeekViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/21/23.
//

import Foundation
import Combine


final class CurriculumListWeekViewModelImpl: CurriculumListWeekViewModel {
    
    private enum FlowType {
        case backButtonTapped
        case articleCellTapped(articleId: Int)
    }
    
    private let manager: CurriculumListManager
    private let navigator: CurriculumListByWeekNavigation
    
    private let navigationSubject = PassthroughSubject<FlowType, Never>()
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private var weekCount: Int = 0
    
    private var curriculumWeekData: CurriculumWeekData?
    
    init(manager: CurriculumListManager, navigator: CurriculumListByWeekNavigation) {
        self.manager = manager
        self.navigator = navigator
        bind()
    }
    
    private func bind() {
        self.navigationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
                case .backButtonTapped:
                    self?.navigator.backButtonTapped()
                case .articleCellTapped(let articleId):
                    self?.navigator.curriculumArticleListCellTapped(articleId: articleId)
                }
            }
            .store(in: &cancelBag)
        
        self.errorSubject
            .sink { error in
                print(error.description)
            }
            .store(in: &cancelBag)
    }
    
    func transform(input: CurriculumListWeekViewModelInput) -> CurriculumListWeekViewModelOutput {
        
        input.articleCellTapped
            .sink { [weak self] indexPath in
                guard let articleId = self?.curriculumWeekData?.articleData[indexPath.row].articleId
                else { return }
                self?.navigationSubject.send(.articleCellTapped(articleId: articleId))
            }
            .store(in: &cancelBag)
        
        let bookMarkCompleted = input.bookmarkButtonTapped
            .flatMap({ (indexPath: IndexPath, isSelected: Bool) -> AnyPublisher<String, Never> in
                return Future<String, NetworkError> { promise in
                    Task {
                        do {
                            guard let articleId = self.curriculumWeekData?.articleData[indexPath.row].articleId
                            else { return }
                            
                            try await self.bookmarkArticle(articleId: articleId, isSelected: isSelected)
                            
                            if isSelected {
                                promise(.success(BookmarkCompleted.save.message))
                            } else {
                                promise(.success(BookmarkCompleted.delete.message))
                            }
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just(BookmarkCompleted.failure.message)
                }
                .eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
        
        input.backButtonTapped
            .sink { [weak self] in self?.navigationSubject.send(.backButtonTapped) }
            .store(in: &cancelBag)
        
        let viewWillAppearSubject = input.viewWillAppearSubject
        let rightButtonTapped = input.rightButtonTapped
        let leftButtonTapped = input.leftButtonTapped
        let articleByWeekData = Publishers.Merge3(viewWillAppearSubject, rightButtonTapped, leftButtonTapped)
            .flatMap { direction -> AnyPublisher<(data: CurriculumWeekData, leftButtonHidden: Bool, rightButtonHidden: Bool), Never> in
                return Future<(data: CurriculumWeekData, leftButtonHidden: Bool, rightButtonHidden: Bool), NetworkError> { promise in
                    Task {
                        do {
                            self.weekCount += direction.addValue
                            let leftButtonHidden = ((5...40) ~= self.weekCount)
                            let rightButtonHidden = ((4..<40) ~= self.weekCount)
                            let articlesByWeek = try await self.manager.getArticleListByWeekInfo(week: self.weekCount)
                            self.curriculumWeekData = articlesByWeek
                            promise(.success((articlesByWeek, leftButtonHidden: leftButtonHidden, rightButtonHidden: rightButtonHidden)))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just((data: CurriculumWeekData(articleData: [], week: 10), leftButtonHidden: true, rightButtonHidden: true))
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return CurriculumListWeekViewModelOutput(articleByWeekData: articleByWeekData,
                                                 bookMarkCompleted: bookMarkCompleted)
    }
    
    private func bookmarkArticle(articleId: Int, isSelected: Bool) async throws {
        try await manager.postBookmark(model: BookmarkRequest(articleId: articleId,
                                                            bookmarkRequestStatus: isSelected))
    }
}

extension CurriculumListWeekViewModelImpl: CurriculumListWeekViewModelPresentable {
    func setWeek(week: Int) {
        self.weekCount = week
    }
}
