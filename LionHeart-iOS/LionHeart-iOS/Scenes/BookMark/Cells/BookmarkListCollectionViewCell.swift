//
//  BookmarkCollectionViewCell.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/11.
//  Copyright (c) 2023 Bookmark. All rights reserved.
//

import UIKit

import SnapKit

private enum Size {
    static let widthHeightRatio: CGFloat = 80/125
}

final class BookmarkListCollectionViewCell: UICollectionViewCell,
                                        CollectionViewCellRegisterDequeueProtocol {
    private let articleImageView = LHImageView(contentMode: .scaleToFill)
    private let articleTitleLabel = LHLabel(type: .title2, color: .white, lines: 2).priorty(.defaultLow, .horizontal)
    private let tagLabel = LHLabel(type: .body4, color: .gray400).priorty(.defaultLow, .horizontal)
    private lazy var bookmarkButton = LHImageButton(setImage: .assetImage(.bookmarkActiveSmall)).priorty(.defaultHigh, .horizontal)
    private let bottomLineView = LHUnderLine(lineColor: .gray800)
    
    var bookmarkButtonClosure: ((IndexPath) -> Void)?
    
    var inputData: ArticleSummaries? {
        didSet {
            guard let inputData else { return }
            
            Task {
                let image = try await LHKingFisherService.fetchImage(with: inputData.articleImage)
                articleImageView.image = image
            }
            
            articleTitleLabel.text = inputData.title
            tagLabel.text =  inputData.tags.joined(separator: " · ")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setButtonAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BookmarkListCollectionViewCell {
    func setHierarchy() {
        addSubviews(articleImageView, articleTitleLabel, tagLabel, bookmarkButton, bottomLineView)
    }
    
    func setLayout() {
        articleImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(125))
            $0.height.equalTo(articleImageView.snp.width).multipliedBy(Size.widthHeightRatio)
        }
        
        articleTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(articleImageView.snp.trailing).offset(13)
            $0.trailing.equalTo(bookmarkButton.snp.leading).offset(-8)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(articleTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(articleTitleLabel)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func setButtonAction() {
        bookmarkButton.addButtonAction { _ in
            guard let indexPath = self.getIndexPath() else { return }
            self.bookmarkButtonClosure?(indexPath)
        }
    }
}
