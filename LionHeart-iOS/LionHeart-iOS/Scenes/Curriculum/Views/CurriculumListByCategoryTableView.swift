//
//  CurriculumListByCategoryTableView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/25.
//

import UIKit

final class CurriculumListByWeekTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .plain)
        self.contentInsetAdjustmentBehavior = .always
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .designSystem(.background)
        self.separatorStyle = .none
        CurriculumArticleByWeekTableViewCell.register(to: self)
        CurriculumArticleByWeekRowZeroTableViewCell.register(to: self)
        let footerView = UIView()
        footerView.backgroundColor = .designSystem(.background)
        footerView.frame.size.height = 76
        self.tableFooterView = footerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
