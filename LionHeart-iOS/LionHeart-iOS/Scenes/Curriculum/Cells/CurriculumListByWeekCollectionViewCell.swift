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
    
    let curriculumListByWeekTableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .designSystem(.background)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var weekCount: Int? {
        didSet {
            curriculumListByWeekTableView.reloadData()
        }
    }
    
    var inputData: CurriculumWeekData? {
        
        didSet {
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
        guard let inputData else { return 0 }
        return (inputData.articleData.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {

            let cell = CurriculumArticleByWeekRowZeroTableViewCell.dequeueReusableCell(to: curriculumListByWeekTableView)
            guard let weekCount else { return CurriculumTableViewCell() }
            cell.inputData = inputData?.week
            return cell
        } else {
            
            let cell = CurriculumArticleByWeekTableViewCell.dequeueReusableCell(to: curriculumListByWeekTableView)
            cell.inputData = inputData?.articleData[indexPath.row - 1]
            cell.selectionStyle = .none
            cell.backgroundColor = .designSystem(.background)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        } else {
            guard let inputData else { return }
            NotificationCenter.default.post(name: NSNotification.Name("didSelectTableViewCell"),
                                            object: inputData.articleData[indexPath.row - 1].articleId)
            
        }
    }
}

extension CurriculumListByWeekCollectionViewCell: UITableViewDelegate {}


