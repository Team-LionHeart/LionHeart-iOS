//
//  MyPageViewModelSpy.swift
//  LionHeart-iOSTests
//
//  Created by 황찬미 on 2023/12/03.
//

import Foundation
import Combine

@testable import LionHeart_iOS

final class MyPageViewModelSpy: MyPageViewModel {
    
    let isBackButtonTapped = PassthroughSubject<Bool, Never>()
    let isResignButtonTapped = PassthroughSubject<Bool, Never>()
    let isViewWillAppearSubject = PassthroughSubject<Bool, Never>()
    
    var myPageModel = MyPageModel.empty
    var cancelBag = Set<AnyCancellable>()
    
    func transform(input: LionHeart_iOS.MyPageViewModelInput) -> LionHeart_iOS.MyPageViewModelOutput {
        input.viewWillAppearSubject
            .sink { [weak self] _ in
                self?.isViewWillAppearSubject.send(true)
            }
            .store(in: &cancelBag)
        
        input.resignButtonTapped
            .sink { [weak self] _ in
                self?.isResignButtonTapped.send(true)
            }
            .store(in: &cancelBag)
        
        input.backButtonTapped
            .sink { [weak self] _ in
                self?.isBackButtonTapped.send(true)
            }
            .store(in: &cancelBag)
        
        let output = Just(myPageModel).eraseToAnyPublisher()
        
        return Output(viewWillAppearSubject: output)
    }
}
