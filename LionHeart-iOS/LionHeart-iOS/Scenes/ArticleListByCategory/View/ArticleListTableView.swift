//
//  ArticleListTableView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import UIKit

final class ArticleListTableView: UITableView {    
    init() {
        super.init(frame: .zero, style: .plain)
        self.backgroundColor = .designSystem(.background)
        let view = ArticleListByCategoryHeaderView()
        view.frame = CGRect(x: 0, y: 0, width: Constant.Screen.width, height: ScreenUtils.getHeight(136))
        self.separatorStyle = .none
        self.tableHeaderView = view
        self.estimatedRowHeight = 326
        
        let footerView = UIView()
        footerView.frame = .init(x: 0, y: 0, width: Constant.Screen.width, height: 100)
        self.tableFooterView = footerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


