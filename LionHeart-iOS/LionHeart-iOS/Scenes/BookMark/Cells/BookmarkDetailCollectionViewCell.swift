//
//  BookmarkDetailCollectionViewCell.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/13.
//  Copyright (c) 2023 BookmarkDetail. All rights reserved.
//

import UIKit

import SnapKit

final class BookmarkDetailCollectionViewCell: UICollectionViewCell, CollectionViewCellRegisterDequeueProtocol {
    
    private let bookmarkDetailLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     사랑이 아빠님이
                     보관한 아티클이에요
                     """
        label.numberOfLines = 2
        label.font = .pretendard(.head3)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    var inputData: BookmarkAppData? {
        didSet {
            guard let inputData else { return }
            bookmarkDetailLabel.text = inputData.nickName +  " 아빠님이\n보관한 아티클이에요"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BookmarkDetailCollectionViewCell {
    func setHierarchy() {
        addSubview(bookmarkDetailLabel)
    }
    
    func setLayout() {
        bookmarkDetailLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
