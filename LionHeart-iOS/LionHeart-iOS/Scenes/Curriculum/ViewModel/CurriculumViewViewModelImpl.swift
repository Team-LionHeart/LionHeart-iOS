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
    
    private var isFirstPresented: Bool = true
    private var curriculumViewDatas = CurriculumMonthData.dummy()
    private var userInfoData: UserInfoData?
    
    private let navigationSubject = PassthroughSubject<FlowType, Never>()
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
//    {
//        didSet {
//            configureUserInfoData()
//        }
//    }
    
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
                self?.navigationSubject.send(.rightArrowButton(index: index))
            }
            .store(in: &cancelBag)
        
        
        let scrollIndexPath = input.viewDidLayoutSubviews
            .map { _ -> IndexPath in
                guard let userInfoData = self.userInfoData else { return IndexPath() }
                let userWeek = userInfoData.userWeekInfo
                let weekPerMonth = 4
                let desireSection = userWeek == 40 ? (userWeek/weekPerMonth)-2 : (userWeek/weekPerMonth)-1
                let desireRow = (userWeek % weekPerMonth)
                let weekDataRow = userWeek == 40 ? desireRow + 4 : desireRow
                self.curriculumViewDatas[desireSection].weekDatas[weekDataRow].isExpanded = true
                
                return IndexPath(row: desireRow, section: desireSection)
            }
            .eraseToAnyPublisher()
        
        
        input.viewWillAppear
            .flatMap { _ -> AnyPublisher<[CurriculumMonthData], Never> in
                
            }
        
        
        return Output(firstScrollIndexPath: scrollIndexPath,
                      curriculumMonth: <#T##AnyPublisher<[CurriculumMonthData], Never>#>,
                      userInfo: <#T##AnyPublisher<UserInfoData, Never>#>)
    }
    
}

extension CurriculumViewViewModelImpl {
    func scrollToUserWeek() {
        guard let userInfoData else { return }
        let userWeek = userInfoData.userWeekInfo
        let weekPerMonth = 4
        let desireSection = userWeek == 40 ? (userWeek/weekPerMonth)-2 : (userWeek/weekPerMonth)-1
        let desireRow = (userWeek % weekPerMonth)
        let indexPath = IndexPath(row: desireRow, section: desireSection)
        let weekDataRow = userWeek == 40 ? desireRow + 4 : desireRow
        curriculumViewDatas[desireSection].weekDatas[weekDataRow].isExpanded = true
        
        
//        self.curriculumTableView.reloadData()
//        self.curriculumTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        
    }
    
    func getCurriculumData() async throws -> UserInfoData {
        return try await manager.getCurriculumServiceInfo()
//        Task {
//            do {
//                userInfoData =
//            } catch {
////                guard let error = error as? NetworkError else { return }
////                handleError(error)
//            }
//        }
    }
    
}
