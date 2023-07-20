//
//  GeneralTitleTableViewCell.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/12.
//  Copyright (c) 2023 GeneralTitle. All rights reserved.
//

import UIKit

import SnapKit

final class GeneralTitleTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head3)
        label.textColor = .designSystem(.gray900)
        label.numberOfLines = 0
        return label
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

private extension GeneralTitleTableViewCell {
    
    func setHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(36)
        }
        
    }

    func configureCell(_ model: ArticleBlockData?) {
        guard let model else { return }
        titleLabel.text = model.content
        titleLabel.setTextWithLineHeight(lineHeight: 32)
    }
    

}
