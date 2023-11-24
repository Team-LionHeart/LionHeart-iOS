//
//  CurriculumViewViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/22/23.
//

import Foundation
import Combine

final class CurriculumViewViewModelImpl: CurriculumViewViewModel, CurriculumViewViewModelPresentable {
    
    private enum FlowType {
        case bookmark
        case myPage
        case rightArrowButton(index: Int)
    }
    
    private let navigator: CurriculumNavigation
    private let manager: CurriculumManager
    
    private var curriculumViewDatas = CurriculumMonthData.dummy()
    private var userInfoData: UserInfoData?
    
    private let navigationSubject = PassthroughSubject<FlowType, Never>()
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    init(navigator: CurriculumNavigation, manager: CurriculumManager) {
        self.navigator = navigator
        self.manager = manager
        bind()
    }
    
    private func bind() {
        navigationSubject
            .receive(on: RunLoop.main)
            .sink { flow in
                switch flow {
                case .bookmark:
                    self.navigator.navigationLeftButtonTapped()
                case .myPage:
                    self.navigator.navigationRightButtonTapped()
                case .rightArrowButton(let index):
                    self.navigator.articleListCellTapped(itemIndex: index)
                }
            }
            .store(in: &cancelBag)
        
        errorSubject
            .sink { error in
                print(error.description)
            }
            .store(in: &cancelBag)
    }
    
    func transform(input: CurriculumViewViewModelInput) -> CurriculumViewViewModelOutput {
        input.bookmarkButtonTapped
            .sink { [weak self] _ in
                self?.navigationSubject.send(.bookmark)
            }
            .store(in: &cancelBag)
        
        input.myPageButtonTapped
            .sink { [weak self] _ in
                self?.navigationSubject.send(.myPage)
            }
            .store(in: &cancelBag)
        
        input.rightArrowButtonTapped
            .sink { [weak self] index in
                let itemIndex = index.section * 4 + index.row + 4
                self?.navigationSubject.send(.rightArrowButton(index: itemIndex))
            }
            .store(in: &cancelBag)
        
        let curriculumMonth = input.viewWillAppear
            .flatMap { _ -> AnyPublisher<(userInfo: UserInfoData, monthData: [CurriculumMonthData]), Never> in
                return Future<(userInfo: UserInfoData, monthData: [CurriculumMonthData]), NetworkError> { promise in
                    Task {
                        do {
                            let userInfo = try await self.getCurriculumData()
                            promise(.success((userInfo: userInfo, monthData: CurriculumMonthData.dummy())))
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }.catch { error in
                    self.errorSubject.send(error)
                    let empty = UserInfoData(userWeekInfo: 0, userDayInfo: 0, progress: 0, remainingDay: 0)
                    let emptyMonth = CurriculumMonthData(month: "1", weekDatas: [])
                    return Just((userInfo: empty, monthData: [emptyMonth]))
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        return Output(curriculumMonth: curriculumMonth)
    }
    
}

extension CurriculumViewViewModelImpl {
    
    func getCurriculumData() async throws -> UserInfoData {
        return try await manager.getCurriculumServiceInfo()
    }
    
}
