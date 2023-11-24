//
//  ArticleCategoryViewModel.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/20/23.
//

import Foundation
import Combine

protocol ArticleCategoryViewModelPresentable {}

protocol ArticleCategoryViewModel: ViewModel where Input == ArticleCategoryViewModelInput, Output == ArticleCategoryViewModelOutput {}

struct ArticleCategoryViewModelInput {
    let viewWillAppear: PassthroughSubject<Void, Never>
    let bookMarkButtonTapped: PassthroughSubject<Void, Never>
    let myPageButtonTapped: PassthroughSubject<Void, Never>
    let categoryCellTapped: PassthroughSubject<IndexPath, Never>
}

struct ArticleCategoryViewModelOutput {
    let categoryTitle: AnyPublisher<[CategoryImage], Never>
}
