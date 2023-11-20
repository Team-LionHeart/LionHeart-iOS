//
//  BookmarkViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/11/19.
//

import Foundation
import Combine

final class BookmarkViewModelImpl: BookmarkViewModel, BookmarkViewModelPresentable {
    
    private enum FlowType {
        case articleCellButtonTapped(id: Int)
        case backButtonTapped
    }
    
    private var bookmarkAppData = BookmarkAppData(nickName: "", articleSummaries: [ArticleSummaries]())
    private let navigator: BookmarkNavigation
    private let manager: BookmarkManager
    
    private let navigationSubject = PassthroughSubject<FlowType, Never>()
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    init(navigator: BookmarkNavigation, manager: BookmarkManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    func transform(input: BookmarkViewModelInput) -> BookmarkViewModelOutput {
        
        navigationSubject
            .receive(on: RunLoop.main)
            .sink { type in
                switch type {
                case .articleCellButtonTapped(let id):
                    self.navigator.bookmarkCellTapped(articleID: id)
                case .backButtonTapped:
                    self.navigator.backButtonTapped()
                }
            }
            .store(in: &cancelBag)
        
        input.articleCellTapped
            .sink { indexPath in
                let articleID = self.bookmarkAppData.articleSummaries[indexPath.item].articleID
                self.navigationSubject.send(.articleCellButtonTapped(id: articleID))
            }
            .store(in: &cancelBag)
        
        input.backButtonTapped
            .sink { _ in
                self.navigationSubject.send(.backButtonTapped)
            }
            .store(in: &cancelBag)
        
        // diffable section model 낼 학교 가면서 의성 오빠 PR 다시 보귀
        
        let viewWillAppear = input.viewWillAppear
            .flatMap { _ -> AnyPublisher<BookmarkSectionModel, Never> in
                return Future<BookmarkSectionModel, NetworkError> { promise in
                    Task {
                        do {
                            self.bookmarkAppData = try await self.manager.getBookmark()
                            
                            let data = self.bookmarkAppData.articleSummaries.map{$0}
                            
                            promise(.success(BookmarkSectionModel(detailData: [BookmarkRow.detail(self.bookmarkAppData.nickName)],
                                                                           listData: [BookmarkRow.list(data)])))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    // 빈 배열 들어갈 예정
//                    return Just([BookmarkSectionModel(detailData: [], listData: [])])
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let bookmarkButtonTapped = input.bookmarkButtonTapped
            .flatMap { indexPath -> AnyPublisher<String, Never> in
                return Future<String, NetworkError> { promise in
                    Task {
                        do {
                            try await self.manager.postBookmark(model: .init(articleId: self.bookmarkAppData.articleSummaries[indexPath.item].articleID, bookmarkRequestStatus: !self.bookmarkAppData.articleSummaries[indexPath.item].bookmarked))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just(error.description)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        errorSubject
            .sink { error in
                print(error)
            }
            .store(in: &cancelBag)
        
        return BookmarkViewModelOutput(viewWillAppear: viewWillAppear,
                                       bookmarkButtonTapped: bookmarkButtonTapped)
    }
}

extension BookmarkViewModelImpl {
    func handleError(_ error: NetworkError) {
//        if case .clientError(let code, _) = error {
//            if code == NetworkErrorCode.unfoundUserErrorCode {
//                DispatchQueue.main.async {
//                    self.navigator.checkUserIsVerified(userState: .nonVerified, kakaoToken: self.token)
//                }
//            }
//        }
    }
}
