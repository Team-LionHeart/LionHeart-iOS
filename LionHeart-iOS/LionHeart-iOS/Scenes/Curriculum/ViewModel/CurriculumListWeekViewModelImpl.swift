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
    
    var selectedIndexPath: IndexPath?
    
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
                            promise(.success("북마크 저장에 성공했습니다."))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just("북마크 저장이 실패했습니다.")
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
            .flatMap { direction -> AnyPublisher<(CurriculumWeekData, Bool, Bool), Never> in
                return Future<(CurriculumWeekData, Bool, Bool), NetworkError> { promise in
                    Task {
                        do {
                            self.weekCount += direction.addValue
                            let leftButtonHidden = ((4...40) ~= self.weekCount - 1)
                            let rightButtonHidden = ((4...40) ~= self.weekCount + 1)
                            let articlesByWeek = try await self.manager.getArticleListByWeekInfo(week: self.weekCount)
                            self.curriculumWeekData = articlesByWeek
                            promise(.success((articlesByWeek, leftButtonHidden, rightButtonHidden)))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just((CurriculumWeekData(articleData: [], week: 10), true, true))
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
