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
        
        let viewWillAppear = input.viewWillAppear
            .flatMap { _ -> AnyPublisher<BookmarkAppData, Never> in
                return Future<BookmarkAppData, NetworkError> { promise in
                    Task {
                        do {
                            self.bookmarkAppData = try await self.manager.getBookmark()
                            promise(.success(self.bookmarkAppData))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just(BookmarkAppData.empty)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let bookmarkButtonTapped = input.bookmarkButtonTapped
            .flatMap { indexPath -> AnyPublisher<(model: BookmarkAppData, message: String), Never> in
                return Future<(model: BookmarkAppData, message: String), NetworkError> { promise in
                    Task {
                        do {
                            try await self.manager.postBookmark(model: .init(articleId: self.bookmarkAppData.articleSummaries[indexPath.item].articleID, bookmarkRequestStatus: !self.bookmarkAppData.articleSummaries[indexPath.item].bookmarked))
                            self.bookmarkAppData.articleSummaries.remove(at: indexPath.item)
                            promise(.success((model: self.bookmarkAppData, message: BookmarkCompleted.delete.message)))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    self.errorSubject.send(error)
                    return Just((model: BookmarkAppData.empty, message: BookmarkCompleted.failure.message))
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
        print(error.description)
    }
}
