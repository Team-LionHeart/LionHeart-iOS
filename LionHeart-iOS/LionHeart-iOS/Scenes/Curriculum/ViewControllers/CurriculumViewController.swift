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

final class CurriculumViewController: UIViewController, CurriculumTableViewToggleButtonTappedProtocol{
    
    private lazy var navigationBar = LHNavigationBarView(type: .curriculumByWeek, viewController: self)
    
    private let userInfoData = UserInfoData.dummy()
    
    private let progressBar: LottieAnimationView = {
        let lottie = LottieAnimationView(name: "progressbar_\(UserInfoData.dummy().progress)m")
        return lottie
    }()
    
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray400)
        label.text = "D-\(UserInfoData.dummy().remainingDay)"
        return label
    }()
    
    
    private let headerHeight: CGFloat = 40.0
    
    private lazy var curriculumUserInfoView: CurriculumUserInfoView = {
        let view = CurriculumUserInfoView()
        view.backgroundColor = .designSystem(.background)
        view.userInfo = userInfoData
        return view
    }()
    
    private enum Size {
        static let userInfoView: CGFloat = 70 / 375
        static let progressView: CGFloat = 124 / 375
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
        
        progressBar.play()
        
    }
    
    override func viewDidLayoutSubviews() {
        if isFirstPresented {
            self.scrollToUserWeek()
        }
    }
}

private extension CurriculumViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        progressBar.addSubview(dDayLabel)
        view.addSubviews(navigationBar, progressBar, curriculumUserInfoView, curriculumTableView, gradientImage)
    }
    
    func setLayout() {
        self.navigationController?.isNavigationBarHidden = true
        navigationBar.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
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
            $0.height.equalTo(progressBar.snp.width).multipliedBy(Size.progressView)
        }
        
        dDayLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(48)
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
    
    // viewDidAppear
    func scrollToUserWeek() {
        let userWeek = userInfoData.userWeekInfo
        let desireSection = (userWeek / 4) - 1
        let desireRow = (userWeek % 4)
        let indexPath = IndexPath(row: desireRow, section: desireSection)
        
        curriculumViewDatas[desireSection].weekDatas[desireRow].isExpanded = true
        
        self.curriculumTableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
}

extension CurriculumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curriculumViewDatas[section].weekDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CurriculumTableViewCell.dequeueReusableCell(to: tableView)
        cell.inputData = curriculumViewDatas[indexPath.section].weekDatas[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        cell.cellIndexPath = indexPath
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
        
        guard let indexPath else { return }
        
        let listByWeekVC = CurriculumListByWeekViewController()
        if indexPath.section == curriculumViewDatas.count - 1 {
            listByWeekVC.firstPresented = (indexPath.section * 4) + indexPath.row + 1
//            listByWeekVC.currentPage = (indexPath.section * 4) + indexPath.row + 1
        } else {
            listByWeekVC.firstPresented = (indexPath.section * 4) + indexPath.row
//            listByWeekVC.currentPage = (indexPath.section * 4) + indexPath.row
        }
        self.navigationController?.pushViewController(listByWeekVC, animated: false)
        
    }
    
}

extension CurriculumViewController: UITableViewDelegate{}
