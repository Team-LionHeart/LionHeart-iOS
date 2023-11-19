//
//  ArticleDetailViewModel.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/20/23.
//

import Foundation
import Combine

protocol ArticleDetailViewModelPresentable {
    func setArticleId(id: Int)
}

protocol ArticleDetailViewModel: ViewModel where Input == ArticleDetailViewModelInput, Output == ArticleDetailViewModelOutput {}

struct ArticleDetailViewModelInput {
    let viewWillAppear: PassthroughSubject<Void, Never>
    let closeButtonTapped: PassthroughSubject<Void, Never>
    let bookmarkButtonTapped: PassthroughSubject<Void, Never>
}

struct ArticleDetailViewModelOutput {
    let articleDetail: AnyPublisher<Result<Article, NetworkError>, Never>
}
