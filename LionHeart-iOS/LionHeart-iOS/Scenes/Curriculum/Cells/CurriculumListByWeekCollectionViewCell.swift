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
    
    let curriculumListByWeekTableView = CurriculumListByWeekTableView()
    
    var weekCount: Int?
    var selectedIndexPath: IndexPath?
    var inputData: CurriculumWeekData? {
        didSet {
            curriculumListByWeekTableView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CurriculumListByWeekCollectionViewCell {
    
    enum Size {
        static let weekBackGroundImageSize: CGFloat = (60 / 375) * Constant.Screen.width
    }
    
    func setUI() {
        backgroundColor = .designSystem(.background)
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
        curriculumListByWeekTableView.dataSource = self
        curriculumListByWeekTableView.delegate = self
    }
}

extension CurriculumListByWeekCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let inputData else { return 0 }
        return inputData.articleData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = CurriculumArticleByWeekRowZeroTableViewCell.dequeueReusableCell(to: curriculumListByWeekTableView)
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
        if indexPath.row != 0 {
            guard let inputData else { return }
            NotificationCenter.default.post(name: NSNotification.Name("didSelectTableViewCell"), object: inputData.articleData[indexPath.row-1].articleId)
        }
    }
}
