//
//  ArticleListByCategoryViewModel.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/20/23.
//

import Foundation
import Combine

protocol ArticleListByCategoryViewModelPresentable {
    func setCategoryTitle(title: String)
}

protocol ArticleListByCategoryViewModel: ViewModel where Input == ArticleListByCategoryViewModelInput, Output == ArticleListByCategoryViewModelOutput {}

struct ArticleListByCategoryViewModelInput {
    let viewWillAppear: PassthroughSubject<Void, Never>
    let backButtonTapped: PassthroughSubject<Void, Never>
    let bookmarkTapped: PassthroughSubject<(isSelected: Bool, indexPath: IndexPath), Never>
    let articleCellTapped: PassthroughSubject<IndexPath, Never>
}

struct ArticleListByCategoryViewModelOutput {
    let articles: AnyPublisher<[ArticleDataByWeek], Never>
    let bookmarkCompleted: AnyPublisher<String, Never>
}
