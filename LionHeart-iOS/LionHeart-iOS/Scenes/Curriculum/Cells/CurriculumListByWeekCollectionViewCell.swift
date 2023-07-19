//
//  CurriculumListByWeekCollectionViewCell.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/14.
//  Copyright (c) 2023 CurriculumListByWeek. All rights reserved.
//

import UIKit

import SnapKit

final class CurriculumListByWeekCollectionViewCell: UICollectionViewCell, CollectionViewCellRegisterDequeueProtocol {
    
    private enum Size {
        static let weekBackGroundImageSize: CGFloat = (60 / 375) * Constant.Screen.width
    }
        
    
    private let curriculumListByWeekTableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .designSystem(.background)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var inputData: CurriculumWeekData?{
        
        didSet{
            curriculumListByWeekTableView.reloadData()
        }
        
    }
    
    var selectedIndexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - autolayout설정
        setLayout()
        
        // MARK: - delegate설정
        setDelegate()
        
        // MARK: - tableView Register 설정
        setTableView()
        
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CurriculumListByWeekCollectionViewCell {
    func setUI() {
        
    }
    
    func setHierarchy() {
        self.contentView.addSubviews(curriculumListByWeekTableView)
    }
    
    func setLayout() {
        curriculumListByWeekTableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func setDelegate() {
        curriculumListByWeekTableView.delegate = self
        curriculumListByWeekTableView.dataSource = self
    }
    
    func setTableView() {
        CurriculumArticleByWeekTableViewCell.register(to: curriculumListByWeekTableView)
        CurriculumArticleByWeekRowZeroTableViewCell.register(to: curriculumListByWeekTableView)
        
        let footerView = UIView()
        footerView.backgroundColor = .designSystem(.background)
        footerView.frame.size.height = 76
        self.curriculumListByWeekTableView.tableFooterView = footerView
    }
}

extension CurriculumListByWeekCollectionViewCell: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputData?.articleData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = CurriculumArticleByWeekRowZeroTableViewCell.dequeueReusableCell(to: curriculumListByWeekTableView)
            cell.inputData = inputData
            cell.cellIndexPath = indexPath
            
            return cell
        } else {
            let cell = CurriculumArticleByWeekTableViewCell.dequeueReusableCell(to: curriculumListByWeekTableView)
            cell.inputData = inputData?.articleData[indexPath.row]
            cell.selectionStyle = .none
            cell.backgroundColor = .designSystem(.background)
            return cell
        }
    }
}

extension CurriculumListByWeekCollectionViewCell: UITableViewDelegate{}


