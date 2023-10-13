//
//  CurriculumViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Curriculum. All rights reserved.
//

import UIKit

import SnapKit
import Lottie

protocol CurriculumNavigation: BarNavigation, ExpireNavigation {
    func articleListCellTapped(itemIndex: Int)
}

protocol CurriculumManager {
    func getCurriculumServiceInfo() async throws -> UserInfoData
}

final class CurriculumViewController: UIViewController, CurriculumTableViewToggleButtonTappedProtocol{
    
    weak var coordinator: CurriculumNavigation?
    private let manager: CurriculumManager

    private lazy var navigationBar = LHNavigationBarView(type: .curriculumMain, viewController: self)
    private let progressBar = LHLottie()
    private let dDayLabel = LHLabel(type: .body3R, color: .gray400)
    private let dDayView = UIView()
    private lazy var curriculumUserInfoView = CurriculumUserInfoView()
    private let gradientImage = LHImageView(in: ImageLiterals.Curriculum.gradient, contentMode: .scaleToFill)
    private let curriculumTableView = CurriculumTableView()
    
    private var isFirstPresented: Bool = true
    private var curriculumViewDatas = CurriculumMonthData.dummy()
    private var userInfoData: UserInfoData? {
        didSet {
            configureUserInfoData()
        }
    }
    
    init(manager: CurriculumManager) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setAddTarget()
    }
    
    override func viewDidLayoutSubviews() {
        if isFirstPresented {
            self.scrollToUserWeek()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showLoading()
        getCurriculumData()
    }
}

private extension CurriculumViewController {
    
    enum Size {
        static let userInfoView: CGFloat = 70 / 375
    }
    
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        dDayView.addSubview(dDayLabel)
        view.addSubviews(navigationBar, progressBar, curriculumUserInfoView, curriculumTableView, gradientImage, dDayView)
    }
    
    func setLayout() {
        self.navigationController?.isNavigationBarHidden = true
        navigationBar.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        dDayView.snp.makeConstraints{
            $0.size.equalTo(100)
            $0.leading.equalToSuperview().inset(48)
            $0.centerY.equalTo(progressBar)
        }
        
        dDayLabel.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        curriculumUserInfoView.snp.makeConstraints{
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(Constant.Screen.width)
            $0.height.equalTo(curriculumUserInfoView.snp.width).multipliedBy(Size.userInfoView)
        }
        
        progressBar.snp.makeConstraints{
            $0.top.equalTo(curriculumUserInfoView.snp.bottom)
            $0.trailing.leading.equalToSuperview()
            $0.width.equalTo(Constant.Screen.width)
            $0.height.equalTo(ScreenUtils.getHeight(180))
        }
        
        curriculumTableView.snp.makeConstraints{
            $0.top.equalTo(progressBar.snp.bottom)
            $0.trailing.bottom.leading.equalToSuperview()
        }
        
        gradientImage.snp.makeConstraints{
            $0.top.equalTo(progressBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func setDelegate() {
        curriculumTableView.dataSource = self
    }
    
    func setAddTarget() {
        navigationBar.rightFirstBarItemAction {
            self.coordinator?.navigationLeftButtonTapped()
        }
        
        navigationBar.rightSecondBarItemAction {
            self.coordinator?.navigationRightButtonTapped()
        }
    }
    
    func scrollToUserWeek() {
        guard let userInfoData else { return }
        let userWeek = userInfoData.userWeekInfo
        let weekPerMonth = 4
        let desireSection = userWeek == 40 ? (userWeek/weekPerMonth)-2 : (userWeek/weekPerMonth)-1
        let desireRow = (userWeek % weekPerMonth)
        let indexPath = IndexPath(row: desireRow, section: desireSection)
        let weekDataRow = userWeek == 40 ? desireRow + 4 : desireRow
        curriculumViewDatas[desireSection].weekDatas[weekDataRow].isExpanded = true
        self.curriculumTableView.reloadData()
        self.curriculumTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        
    }
    
    func configureUserInfoData() {
        guard let userInfoData else { return }
        dDayLabel.text = "D-\(userInfoData.remainingDay)"
        let progressName: String = "progressbar_\(userInfoData.progress)m"
        progressBar.animation = .named(progressName)
        progressBar.play()
        curriculumUserInfoView.userInfo = userInfoData
    }
}

extension CurriculumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curriculumViewDatas[section].weekDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CurriculumTableViewCell.dequeueReusableCell(to: tableView)
        let data = curriculumViewDatas[indexPath.section].weekDatas[indexPath.row]
        cell.inputData = data
        cell.selectionStyle = .none
        cell.delegate = self
        cell.cellIndexPath = indexPath
        cell.curriculumToggleDirectionButton.isSelected = data.isExpanded
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return curriculumViewDatas.count
    }
    
    func toggleButtonTapped(indexPath: IndexPath?) {
        self.isFirstPresented = false
        guard let indexPath  else { return }
        let previousWeekDatas = curriculumViewDatas[indexPath.section].weekDatas[indexPath.row]
        curriculumViewDatas[indexPath.section].weekDatas[indexPath.row].isExpanded = !previousWeekDatas.isExpanded
        curriculumTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func moveToListByWeekButtonTapped(indexPath: IndexPath?) {
        guard let indexPath else { return }
        coordinator?.articleListCellTapped(itemIndex: indexPath.section * 4 + indexPath.row)
    }
}

extension CurriculumViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .unAuthorizedError:
            self.coordinator?.checkTokenIsExpired()
        case .clientError(_, let message):
            LHToast.show(message: "\(message)")
        default:
            LHToast.show(message: error.description)
        }
    }
}

extension CurriculumViewController {
    func getCurriculumData() {
        Task {
            do {
                userInfoData = try await manager.getCurriculumServiceInfo()
                hideLoading()
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}
