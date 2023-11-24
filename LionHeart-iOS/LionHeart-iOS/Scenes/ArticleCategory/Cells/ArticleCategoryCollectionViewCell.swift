//
//  ArticleCategoryCollectionViewCell.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/11.
//  Copyright (c) 2023 ArticleCategory. All rights reserved.
//

import UIKit

import SnapKit

final class ArticleCategoryCollectionViewCell: UICollectionViewCell, CollectionViewCellRegisterDequeueProtocol {

    private let categoryImageView = LHImageView(contentMode: .scaleToFill).makeRound(10)
    private let categoryInfoLabel = LHLabel(type: .title1, color: .white)
    
    var categorayClosure: ((String) -> Void)?
    var inputData: CategoryImage? {
        didSet {
            guard let data = inputData else { return }
            categoryImageView.image = data.image
            categoryInfoLabel.text = data.infoDescription
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ArticleCategoryCollectionViewCell {
    func setUI() {
        categoryInfoLabel.backgroundColor = .designSystem(.clear)
        backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        contentView.addSubview(categoryImageView)
        categoryImageView.addSubview(categoryInfoLabel)
    }
    
    func setLayout() {
        categoryImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        categoryInfoLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(8)
        }
    }
}
