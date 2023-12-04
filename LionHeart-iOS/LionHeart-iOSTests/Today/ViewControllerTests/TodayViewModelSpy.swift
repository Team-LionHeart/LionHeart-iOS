//
//  TodayViewModelSpy.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 11/30/23.
//

import Foundation
import Combine

@testable import LionHeart_iOS

final class TodayViewModelSpy: TodayViewModel {
    
    var isViewWillAppeared = PassthroughSubject<Bool, Never>()
    var isArticleTapped = PassthroughSubject<Bool, Never>()
    var isNaviLeftButtonTapped = PassthroughSubject<Bool, Never>()
    var isNaviRightButtonTapped = PassthroughSubject<Bool, Never>()
    
    var todayArticle: TodayArticle = TodayArticle.emptyArticle
    
    private var cancelBag = Set<AnyCancellable>()
    
    func transform(input: LionHeart_iOS.TodayViewModelInput) -> LionHeart_iOS.TodayViewModelOutput {
        
        input.viewWillAppearSubject
            .sink { [weak self] _ in
                self?.isViewWillAppeared.send(true)
            }
            .store(in: &cancelBag)
        
        input.navigationLeftButtonTapped
            .sink { [weak self] _ in
                self?.isNaviLeftButtonTapped.send(true)
            }
            .store(in: &cancelBag)
        
        input.navigationRightButtonTapped
            .sink { [weak self] _ in
                self?.isNaviRightButtonTapped.send(true)
            }
            .store(in: &cancelBag)
        
        input.todayArticleTapped
            .sink { [weak self] _ in
                self?.isArticleTapped.send(true)
            }
            .store(in: &cancelBag)
        
        
        let output = Just(todayArticle).eraseToAnyPublisher()
        
        return Output(viewWillAppearSubject: output)
    }
}
