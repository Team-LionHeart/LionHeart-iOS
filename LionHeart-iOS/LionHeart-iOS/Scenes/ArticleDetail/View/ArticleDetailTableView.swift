//
//  ArticleDetailTableView.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/12.
//

import UIKit

class ArticleDetailTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setUI()
        registerCell()
        setTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        self.backgroundColor = .designSystem(.background)
    }

    private func setTableView() {
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 250
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
    }

    private func registerCell() {
        ThumnailTableViewCell.register(to: self)
        TitleTableViewCell.register(to: self)
        EditorTableViewCell.register(to: self)
        ChapterTitleTableViewCell.register(to: self)
        BodyTableViewCell.register(to: self)
        GeneralTitleTableViewCell.register(to: self)
        CopyRightTableViewCell.register(to: self)
    }
}
