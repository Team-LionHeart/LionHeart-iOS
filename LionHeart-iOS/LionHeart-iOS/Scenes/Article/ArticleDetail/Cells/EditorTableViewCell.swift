//
//  EditorTableViewCell.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/12.
//  Copyright (c) 2023 Editor. All rights reserved.
//

import UIKit

import SnapKit

final class EditorTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {

    var inputData: ArticleBlockData? {
        didSet {
            configureCell(inputData)
        }
    }

    private let editorBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.backgroundColor = .designSystem(.gray100)
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2M)
        label.textColor = .designSystem(.gray900)
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.gray900)
        label.numberOfLines = 0
        return label
    }()
    

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

private extension EditorTableViewCell {
    
    func setHierarchy() {
        contentView.addSubviews(editorBackgroundView)
        editorBackgroundView.addSubviews(titleLabel, commentLabel)
    }
    
    func setLayout() {
        editorBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(72)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(16)
        }

        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
        
    }
    
    func configureCell(_ model: ArticleBlockData?) {
        guard let model else { return }
        titleLabel.text = model.caption
        commentLabel.text = model.content
    }
}
