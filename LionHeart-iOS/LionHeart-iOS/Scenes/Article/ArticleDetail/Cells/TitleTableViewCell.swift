//
//  TitleTableViewCell.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/12.
//  Copyright (c) 2023 Title. All rights reserved.
//

import UIKit

import SnapKit

final class TitleTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head1)
        label.textColor = .designSystem(.gray900)
        label.numberOfLines = 2
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray700)
        return label
    }()

    private let seperatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray100)
        return view
    }()

    var inputData: ArticleBlockData? {
        didSet {
            configureCell(inputData)
        }
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TitleTableViewCell {
    
    func setHierarchy() {
        contentView.addSubviews(titleLabel, authorLabel, seperatorLineView)
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(60)
        }

        seperatorLineView.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(16)
            make.width.equalTo(Constant.Screen.width)
            make.height.equalTo(1)
        }

    }

    func configureCell(_ model: ArticleBlockData?) {
        guard let model else { return }
        titleLabel.text = model.content
        authorLabel.text = "by. \(model.caption ?? "")"
    }
}
