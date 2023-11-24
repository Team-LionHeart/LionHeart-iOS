//
//  BookmarkViewModel.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/11/19.
//

import Foundation
import Combine

protocol BookmarkViewModelPresentable { }

protocol BookmarkViewModel: ViewModel where Input == BookmarkViewModelInput, Output == BookmarkViewModelOutput {}

struct BookmarkViewModelInput {
    let viewWillAppear: PassthroughSubject<Void, Never>
    let articleCellTapped: PassthroughSubject<IndexPath, Never>
    let bookmarkButtonTapped: PassthroughSubject<IndexPath, Never>
    let backButtonTapped: PassthroughSubject<Void, Never>
}

struct BookmarkViewModelOutput {
    let viewWillAppear: AnyPublisher<BookmarkAppData, Never>
    let bookmarkButtonTapped: AnyPublisher<(model: BookmarkAppData, message: String), Never>
}
