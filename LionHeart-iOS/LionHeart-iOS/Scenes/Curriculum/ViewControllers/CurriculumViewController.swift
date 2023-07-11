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
    
    private let curriculumTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
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
        view.backgroundColor = .gray
    }
    
    func setHierarchy() {
        view.addSubviews(curriculumTableView)

    }
    
    func setLayout() {
        curriculumTableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
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
    
}

extension CurriculumViewController: UITableViewDelegate{}
