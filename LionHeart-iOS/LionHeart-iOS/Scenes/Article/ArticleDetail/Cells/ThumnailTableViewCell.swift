//
//  ThumnailTableViewCell.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/12.
//  Copyright (c) 2023 Thumnail. All rights reserved.
//

import UIKit

import SnapKit

final class ThumnailTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {
    
    private let gradientImageView = LHImageView(in: ImageLiterals.Curriculum.gradient, contentMode: .scaleAspectFill)
    private let thumbnailImageView = LHImageView(contentMode: .scaleAspectFill)
    private let imageCaptionLabel = LHLabel(type: .body4, color: .gray500)
    private lazy var bookMarkButton = LHToggleImageButton(normal: ImageLiterals.BookMark.inactiveBookmarkBig, select: ImageLiterals.BookMark.activeBookmarkBig)

    var bookmarkButtonDidTap: ((Bool) -> Void)?
    var inputData: ArticleBlockData? {
        didSet {
            configureCell(inputData)
        }
    }

    var isMarked: Bool? {
        didSet {
            guard let isMarked else { return }
            bookMarkButton.isSelected = isMarked
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        self.thumbnailImageView.image = nil
    }
}

private extension ThumnailTableViewCell {
    
    enum Size {
        static let thumbnailWidthHeightRatio: CGFloat = 224 / 375
    }
    
    func setHierarchy() {
        contentView.addSubviews(thumbnailImageView, imageCaptionLabel, bookMarkButton)
        thumbnailImageView.addSubview(gradientImageView)
    }
    
    func setLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(Constant.Screen.width)
            make.height.equalTo(thumbnailImageView.snp.width).multipliedBy(Size.thumbnailWidthHeightRatio)
        }

        gradientImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        imageCaptionLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            make.centerX.equalTo(thumbnailImageView)
            make.bottom.equalToSuperview().inset(22)
        }

        bookMarkButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
        }

    }

    
    func configureCell(_ model: ArticleBlockData?) {
        guard let model else { return }
        Task {
            let image = try await LHKingFisherService.fetchImage(with: model.content)
            thumbnailImageView.image = image
        }
        imageCaptionLabel.text = model.caption
    }
    
    func setAddTarget() {
        bookMarkButton.addButtonAction { [weak self] _ in
            guard let self else { return }
            self.isSelected.toggle()
            self.bookmarkButtonDidTap?(self.isSelected)
        }
    }
}

extension ThumnailTableViewCell {
    func setThumbnailImageView() {
        bookMarkButton.isHidden = false
        gradientImageView.isHidden = false
    }

    func setImageTypeCell() {
        imageCaptionLabel.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(72)
        }
        gradientImageView.isHidden = true
        bookMarkButton.isHidden = true
    }
}
