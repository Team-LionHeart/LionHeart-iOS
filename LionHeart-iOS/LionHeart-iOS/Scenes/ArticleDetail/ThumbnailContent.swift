//
//  ThumbnailContent.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 1/16/24.
//

import UIKit


final class ThumbnailContent: UIView {
    enum Size {
        static let thumbnailWidthHeightRatio: CGFloat = 224 / 375
    }
    
    var onSelect: (() -> Void)?
    
    private let gradientImageView = LHImageView(in: ImageLiterals.Curriculum.gradient, contentMode: .scaleAspectFill)
    let thumbnailImageView = LHImageView(contentMode: .scaleAspectFill)
    private let imageCaptionLabel = LHLabel(type: .body4, color: .gray500)
    private lazy var bookMarkButton = LHToggleImageButton(normal: ImageLiterals.BookMark.inactiveBookmarkBig, select: ImageLiterals.BookMark.activeBookmarkBig)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHierarchy() {
        self.addSubviews(thumbnailImageView, imageCaptionLabel, bookMarkButton)
        thumbnailImageView.addSubview(gradientImageView)
    }
    
    private func setLayout() {
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
    
    private func setAddTarget() {
        bookMarkButton.addButtonAction { [weak self] _ in
            guard let self else { return }
            self.bookMarkButton.isSelected.toggle()
            onSelect?()
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
