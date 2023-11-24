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
                let itemIndex = index.section * 4 + index.row + 4
                self?.navigationSubject.send(.rightArrowButton(index: itemIndex))
            }
            .store(in: &cancelBag)
        
//        let toggleButtonTapped = input.toggleButtonTapped
//            .map { [weak self] indexPath -> [CurriculumMonthData] in
//                guard let self = self else { return [] }
//                let previousWeekDatas = self.curriculumViewDatas[indexPath.section].weekDatas[indexPath.row]
//                self.curriculumViewDatas[indexPath.section].weekDatas[indexPath.row].isExpanded = !previousWeekDatas.isExpanded
//                return self.curriculumViewDatas
//            }
//            .eraseToAnyPublisher()
        
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
        
//        
//        
//        
//        
//            .map {
//                return CurriculumMonthData.dummy()
//            }
//            .eraseToAnyPublisher()
        
        
            
        
        
        return Output(curriculumMonth: curriculumMonth)
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
