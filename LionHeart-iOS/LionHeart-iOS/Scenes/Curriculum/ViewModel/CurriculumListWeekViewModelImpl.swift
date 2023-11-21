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
    private enum FlowType { 
        case backButtonTapped
        case articleCellTapped(articleId: Int)
    }
    private let navigationSubject = PassthroughSubject<FlowType, Never>()
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    var weekCount: Int?
    
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
    }
    
    func transform(input: CurriculumListWeekViewModelInput) -> CurriculumListWeekViewModelOutput {
        let viewWillAppearSubject = input.viewWillAppearSubject
            .flatMap { _ -> AnyPublisher<CurriculumWeekData, Never> in
                return Future<CurriculumWeekData, NetworkError> { promise in
                    Task {
                        do {
                            guard let weekCount = self.weekCount else { return }
                            let articlesByWeek = try await self.manager.getArticleListByWeekInfo(week: weekCount)
                            self.curriculumWeekData = articlesByWeek
                            promise(.success(articlesByWeek))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just(CurriculumWeekData(articleData: [.init(articleId: 0, articleTitle: "", articleImage: "", articleContent: "", articleReadTime: 0, isArticleBookmarked: false, articleTags: [])], week: 10))
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
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

        return CurriculumListWeekViewModelOutput(articleByWeekData: viewWillAppearSubject,
                                                 bookMarkCompleted: bookMarkCompleted)
    }
    
    func bookmarkArticle(articleId: Int, isSelected: Bool) async throws {
        try await manager.postBookmark(model: BookmarkRequest(articleId: articleId,
                                                            bookmarkRequestStatus: isSelected))
//        Task {
//            do {
//                guard let indexPath = notification.userInfo?["bookmarkCellIndexPath"] as? Int else { return }
//                guard let buttonSelected = notification.userInfo?["bookmarkButtonSelected"] as? Bool else { return }
//                guard let listByWeekDatas else { return }
//                self.listByWeekDatas?.articleData[indexPath].isArticleBookmarked.toggle()
//                try await manager.postBookmark(model: BookmarkRequest(articleId: articleId,
//                                                                    bookmarkRequestStatus: isSelected))
//            } catch {
//                guard let error = error as? NetworkError else { return }
//                handleError(error)
//            }
//        }
    }
    
    
    
    func setWeek(week: Int) {
        self.weekCount = week
    }
}

