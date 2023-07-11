//
//  CurriculumViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Curriculum. All rights reserved.
//

import UIKit

import SnapKit

final class CurriculumViewController: UIViewController{
    
    let curriculumUserInfoView = CurriculumUserInfoView()
    
    private enum Size {
        static let userInfoView: CGFloat = 158 / 375
    }
    
    private let gradientImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "gradient1"))
        return image
    }()
    
    private let curriculumTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .clear
        tableView.sectionFooterHeight = 40
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    private let curriculumViewDatas = CurriculumMonthData.dummy()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - autolayout설정
        setLayout()
        
        // MARK: - button의 addtarget설정
        setAddTarget()
        
        // MARK: - delegate설정
        setDelegate()
        
        // MARK: - tableView Register설정
        setTableView()
    }
}

private extension CurriculumViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(curriculumUserInfoView, curriculumTableView, gradientImage)
    }
    
    func setLayout() {
        curriculumUserInfoView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(Constant.Screen.width)
            $0.height.equalTo(curriculumUserInfoView.snp.width).multipliedBy(Size.userInfoView)
            
        }
        
        curriculumTableView.snp.makeConstraints{
            $0.top.equalTo(curriculumUserInfoView.snp.bottom)
            $0.trailing.bottom.leading.equalToSuperview()
        }
        
        gradientImage.snp.makeConstraints{
            $0.top.equalTo(curriculumUserInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        curriculumTableView.dataSource = self
        curriculumTableView.delegate = self
    }
    
    func setTableView(){
        CurriculumTableViewCell.register(to: curriculumTableView)
        curriculumTableView.register(CurriculumTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: CurriculumTableViewHeaderView.identifier)
        
    }
}

extension CurriculumViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curriculumViewDatas[section].weekDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CurriculumTableViewCell.dequeueReusableCell(to: tableView)
        cell.inputData = curriculumViewDatas[indexPath.section].weekDatas[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return curriculumViewDatas.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CurriculumTableViewHeaderView(reuseIdentifier: CurriculumTableViewHeaderView.identifier)
        
        let month = curriculumViewDatas[section].month
        headerView.configureHeaderView(month: month)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
        
    }
    
    
    
}

extension CurriculumViewController: UITableViewDelegate{}
