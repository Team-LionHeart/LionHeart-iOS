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

    private enum Size {
        static let thumbnailWidthHeightRatio: CGFloat = 224 / 375
    }

    var bookmarkButtonDidTap: (() -> Void)?

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let imageCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.gray500)
        return label
    }()

    private lazy var bookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.addTarget(self, action: #selector(handleBookmarkButtonTap), for: .touchUpInside)
        return button
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

    @objc
    func handleBookmarkButtonTap() {
        bookmarkButtonDidTap?()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ThumnailTableViewCell {
    
    func setHierarchy() {
        contentView.addSubviews(thumbnailImageView, imageCaptionLabel, bookMarkButton)

//        thumbnailImageView.addSubview(bookMarkButton)
    }
    
    func setLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(Constant.Screen.width)
            make.height.equalTo(thumbnailImageView.snp.width).multipliedBy(Size.thumbnailWidthHeightRatio)
        }

        imageCaptionLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            make.centerX.equalTo(thumbnailImageView)
            make.bottom.equalToSuperview().inset(22)
        }

//        bookMarkButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(10)
//            make.trailing.equalToSuperview().inset(10)
//        }

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
}

extension ThumnailTableViewCell {
    func setImageTypeCell() {
        imageCaptionLabel.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(72)
        }
        bookMarkButton.isHidden = true
    }
}
