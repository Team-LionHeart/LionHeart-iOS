//
//  CurriculumTableView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import UIKit

final class CurriculumTableView: UITableView {
    
    init() {
        super.init(frame: .zero, style: .insetGrouped)
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 200
        self.backgroundColor = .clear
        self.sectionFooterHeight = 40
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        CurriculumTableViewCell.register(to: self)
        self.register(CurriculumTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: CurriculumTableViewHeaderView.className)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

