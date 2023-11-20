//
//  MyPageTableView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/20.
//

import UIKit

final class MyPageTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .plain)
        self.contentInsetAdjustmentBehavior = .always
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .designSystem(.background)
        self.separatorStyle = .none
        MyPageCustomerServiceTableViewCell.register(to: self)
        MyPageAppSettingTableViewCell.register(to: self)
        self.register(MyPageTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MyPageTableSectionHeaderView.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
