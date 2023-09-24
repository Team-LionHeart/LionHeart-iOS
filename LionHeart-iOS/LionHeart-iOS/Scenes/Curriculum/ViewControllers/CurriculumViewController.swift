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

protocol CurriculumManager {
    func getCurriculumServiceInfo() async throws -> UserInfoData
}

final class CurriculumViewController: UIViewController, CurriculumTableViewToggleButtonTappedProtocol{
    
    private lazy var navigationBar = LHNavigationBarView(type: .curriculumMain, viewController: self)
    
    private var userInfoData: UserInfoData? {
        didSet {
            configureUserInfoData()
        }
    }
    
    private let manager: CurriculumManager
    
    init(manager: CurriculumManager) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let progressBar = LottieAnimationView()
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray400)
        return label
    }()
    
    private let dDayView = UIView()
    
    private let headerHeight: CGFloat = 40.0
    
    private lazy var curriculumUserInfoView: CurriculumUserInfoView = {
        let view = CurriculumUserInfoView()
        view.backgroundColor = .designSystem(.background)
        return view
    }()
    
    private enum Size {
        static let userInfoView: CGFloat = 70 / 375
    }
    
    private var isFirstPresented: Bool = true
    
    private let gradientImage: UIImageView = {
        let image = UIImageView(image: ImageLiterals.Curriculum.gradient)
        return image
    }()
    
    private let curriculumTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.backgroundColor = .clear
        tableView.sectionFooterHeight = 40
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private var curriculumViewDatas = CurriculumMonthData.dummy()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - autolayout설정
        setLayout()
        
        // MARK: - delegate설정
        setDelegate()
        
        // MARK: - tableView Register설정
        setTableView()
        
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
        curriculumTableView.delegate = self
    }
    
    func setTableView(){
        CurriculumTableViewCell.register(to: curriculumTableView)
        curriculumTableView.register(CurriculumTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: CurriculumTableViewHeaderView.className)
        
    }
    
    func setAddTarget() {
        navigationBar.rightFirstBarItemAction {
            let bookmarkViewController = BookmarkViewController(serviceProtocol: BookmarkService(bookmarkAPIProtocol: BookmarkAPI(apiService: APIService())))
            self.navigationController?.pushViewController(bookmarkViewController, animated: true)
        }
        
        navigationBar.rightSecondBarItemAction {
            let wrapper = AuthMyPageServiceWrapper(authAPIService: AuthAPI(apiService: APIService()), mypageAPIService: MyPageAPI(apiService: APIService()))
            let myPageViewController = MyPageViewController(service: wrapper)
            self.navigationController?.pushViewController(myPageViewController, animated: true)
        }
    }
    
    /// 더미데이터에서는 더미데이터를가지고 tableview를 그리고  아래함수를 호출했었음
    /// 근데 데이터를 api로 받아오려고보니 해당함수를 호출할때는 api로 데이터가 받아와지기전임(데이터를 받아오는데 시간이 오래 걸리때문)
    /// 시간이 걸려서 데이터를 받아오니 expand가 안됨
    // viewDidLayoutSubviews
    func scrollToUserWeek() {
        
        guard let userInfoData else { return }
        
        let userWeek = userInfoData.userWeekInfo
        
        if userWeek == 40 {
            let weekPerMonth = 4
            let desireSection = (userWeek / weekPerMonth) - 2
            let desireRow = (userWeek % weekPerMonth)
            let indexPath = IndexPath(row: desireRow, section: desireSection)
            
            curriculumViewDatas[desireSection].weekDatas[desireRow+4].isExpanded = true
            self.curriculumTableView.reloadData()
            self.curriculumTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        } else {
            let weekPerMonth = 4
            let desireSection = (userWeek / weekPerMonth) - 1
            let desireRow = (userWeek % weekPerMonth)
            let indexPath = IndexPath(row: desireRow, section: desireSection)
            
            curriculumViewDatas[desireSection].weekDatas[desireRow].isExpanded = true
            self.curriculumTableView.reloadData()
            self.curriculumTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CurriculumTableViewHeaderView(reuseIdentifier: CurriculumTableViewHeaderView.className)
        let month = curriculumViewDatas[section].month
        headerView.configureHeaderView(month: month)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func toggleButtonTapped(indexPath: IndexPath?) {
        self.isFirstPresented = false
        guard let indexPath  else { return }
        
        let previousWeekDatas = curriculumViewDatas[indexPath.section].weekDatas[indexPath.row]
        
        curriculumViewDatas[indexPath.section].weekDatas[indexPath.row].isExpanded = !previousWeekDatas.isExpanded
        curriculumTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func moveToListByWeekButtonTapped(indexPath: IndexPath?) {
        
        guard let indexPath else {
            return
            
        }
        
        let listByWeekVC = CurriculumListByWeekViewController(serviceProtocol: BookmarkService(bookmarkAPIProtocol: BookmarkAPI(apiService: APIService())))
        listByWeekVC.weekToIndexPathItem = (indexPath.section * 4) + indexPath.row
        self.navigationController?.pushViewController(listByWeekVC, animated: true)
        
    }
    
    
}

extension CurriculumViewController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let curriculumListByWeekViewController = CurriculumListByWeekViewController()
//        self.navigationController?.pushViewController(curriculumListByWeekViewController, animated: true)
//    }
}

extension CurriculumViewController: ViewControllerServiceable {
    
    func handleError(_ error: NetworkError) {
        switch error {
        case .unAuthorizedError:
            guard let window = self.view.window else { return }
            ViewControllerUtil.setRootViewController(window: window, viewController: SplashViewController(authService: AuthMyPageServiceWrapper(authAPIService: AuthAPI(apiService: APIService()), mypageAPIService: MyPageAPI(apiService: APIService()))), withAnimation: false)
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
                let responseCurriculum = try await manager.getCurriculumServiceInfo()
                
                userInfoData = responseCurriculum
                hideLoading()
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
    
}
