//
//  ArticleCategoryViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/20/23.
//

import Foundation
import Combine

final class ArticleCategoryViewModelImpl: ArticleCategoryViewModel, ArticleCategoryViewModelPresentable {
    
    private enum FlowType {
        case bookmark
        case myPage
        case category(title: String)
    }
    
    private let navigator: ArticleCategoryNavigation
    
    private let categoryTitles = CategoryImage.dummy()
    
    private let navigationSubject = PassthroughSubject<FlowType, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    init(navigator: ArticleCategoryNavigation) {
        self.navigator = navigator
    }
    
    func transform(input: ArticleCategoryViewModelInput) -> ArticleCategoryViewModelOutput {
        
        navigationSubject
            .receive(on: RunLoop.main)
            .sink { flow in
                switch flow {
                case .bookmark:
                    self.navigator.navigationLeftButtonTapped()
                case .myPage:
                    self.navigator.navigationRightButtonTapped()
                case .category(let title):
                    self.navigator.articleListCellTapped(categoryName: title)
                }
            }
            .store(in: &cancelBag)
        
        input.bookMarkButtonTapped
            .sink { _ in
                self.navigationSubject.send(.bookmark)
            }
            .store(in: &cancelBag)
        
        input.categoryCellTapped
            .sink { [weak self] indexPath in
                guard let self else { return }
                let title = self.categoryTitles[indexPath.row].categoryString
                self.navigationSubject.send(.category(title: title))
            }
            .store(in: &cancelBag)
        
        input.myPageButtonTapped
            .sink { _ in
                self.navigationSubject.send(.myPage)
            }
            .store(in: &cancelBag)
        
        let categoryTitles = input.viewWillAppear
            .map { _ in
                return CategoryImage.dummy()
            }
            .eraseToAnyPublisher()
        
        return Output(categoryTitle: categoryTitles)
    }
}

