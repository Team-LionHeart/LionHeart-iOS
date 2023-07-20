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
    
    var categorayClosure: ((String) -> Void)?
    
    var inputData: CategoryImage? {
        didSet {
            guard let data = inputData else { return }
            categoryImageView.image = data.image
            categoryInfoLabel.text = data.infoDdescription
        }
    }
    
    private let categoryImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleToFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 10
        return imageview
    }()
    
    private let categoryInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor =  .designSystem(.white)
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - autolayout설정
        setLayout()
        
        // MARK: - button의 addtarget설정
        setAddTarget()
        
        // MARK: - delegate설정
        setDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ArticleCategoryCollectionViewCell {
    func setUI() {
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
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
}
