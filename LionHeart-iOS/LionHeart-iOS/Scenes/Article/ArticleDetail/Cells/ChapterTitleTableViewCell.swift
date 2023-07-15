//
//  ChapterTitleTableViewCell.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/12.
//  Copyright (c) 2023 ChapterTitle. All rights reserved.
//

import UIKit

import SnapKit

final class ChapterTitleTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {

    private let chapterTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head2)
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
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - autolayout설정
        setLayout()

    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ChapterTitleTableViewCell {
    
    func setHierarchy() {
        contentView.addSubview(chapterTitleLabel)
    }
    
    func setLayout() {
        chapterTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
        }
        
    }

    func configureCell(_ model: ArticleBlockData?) {
        guard let model else { return }
        chapterTitleLabel.text = model.content
    }

}
