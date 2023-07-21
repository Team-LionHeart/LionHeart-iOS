//
//  BodyTableViewCell.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/12.
//  Copyright (c) 2023 Body. All rights reserved.
//

import UIKit

import SnapKit

final class BodyTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2R2)
        label.textColor = .designSystem(.gray900)
        label.numberOfLines = 0
        return label
    }()

    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray500)
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

private extension BodyTableViewCell {
    
    func setHierarchy() {
        contentView.addSubviews(bodyLabel, captionLabel)
    }
    
    func setLayout() {
        bodyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(72)
        }

//        captionLabel.snp.makeConstraints { make in
//            make.top.equalTo(bodyLabel.snp.bottom).offset(8)
//            make.leading.trailing.equalTo(bodyLabel)
//        }
        
    }

    //TODO: - caption이 있으면 isHidden true? 든 뭐든 키고, bottom inset값 바꾸기

    func configureCell(_ model: ArticleBlockData?) {
        guard let model else { return }
        if let caption = model.caption {
            captionLabel.text = caption
            captionLabel.setTextWithLineHeight(lineHeight: 22)
            captionLabel.snp.makeConstraints { make in
                make.top.equalTo(bodyLabel.snp.bottom).offset(8)
                make.leading.trailing.equalTo(bodyLabel)
                make.bottom.equalToSuperview().inset(32)
            }
            bodyLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
            }
        }
        bodyLabel.text = model.content
        bodyLabel.setTextWithLineHeight(lineHeight: 26)
    }

    func updateBottomInset() {

    }
}
