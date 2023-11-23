//
//  CurriculumArticleByWeekTableViewCell.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/14.
//  Copyright (c) 2023 CurriculumArticleByWeek. All rights reserved.
//

import UIKit

import SnapKit


final class CurriculumArticleByWeekTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {
    
    var inputData: ArticleDataByWeek? {
        didSet {
            guard let inputData else { return }
            configureData(inputData)
        }
    }

    var bookMarkButtonTapped: ((Bool, IndexPath) -> Void)?
    
    private let tableViewCellWholeView = UIView()
    private let articleTitleLabel = LHLabel(type: .head3, color: .white)
    private let articleTagLabel = LHLabel(type: .body4, color: .gray400)
    private let articleReadTimeLabel = LHLabel(type: .body4, color: .gray500)
    private let articleContentLabel = LHLabel(type: .body3R, color: .gray300, lines: 2)
    lazy var bookMarkButton = LHToggleImageButton(normal: ImageLiterals.BookMark.inactiveBookmarkSmall,
                                                          select: ImageLiterals.BookMark.activeBookmarkSmall)
    private let articleImageView = LHImageView(contentMode: .scaleToFill).makeRound(4).opacity(0.4)
    private let readTimeAndBookmarkView = LHView(color: .designSystem(.black)).makeRound(4).opacity(0.6)
        .maskedCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CurriculumArticleByWeekTableViewCell {
    
    enum Size {
        static let readTimeAndBookmarkViewSize: CGFloat = 44 / 335
        static let articleImageSize: CGFloat = 200 / 335
    }
    
    func setUI() {
        backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        articleImageView.addSubviews(readTimeAndBookmarkView)
        tableViewCellWholeView.addSubviews(articleImageView, articleTagLabel, articleTitleLabel, articleContentLabel, articleReadTimeLabel, bookMarkButton)
        contentView.addSubviews(tableViewCellWholeView)
    }
    
    func setLayout() {
        
        tableViewCellWholeView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(36)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        articleImageView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(articleImageView.snp.width).multipliedBy(Size.articleImageSize)
        }
        
        readTimeAndBookmarkView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        bookMarkButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        articleReadTimeLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalTo(bookMarkButton)
            
        }
        
        articleTagLabel.snp.makeConstraints{
            $0.top.equalTo(articleImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        articleTitleLabel.snp.makeConstraints{
            $0.top.equalTo(articleTagLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        
        articleContentLabel.snp.makeConstraints{
            $0.top.equalTo(articleTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setAddTarget() {
        bookMarkButton.addButtonAction { [weak self] _ in
            guard let self else { return }
            guard var indexPath = self.getIndexPath() else { return }
            self.isSelected.toggle()
            self.bookMarkButtonTapped?(self.isSelected, indexPath)
            NotificationCenter.default.post(name: NSNotification.Name("isArticleBookmarked"),
                                            object: nil, userInfo: ["bookmarkCellIndexPath": max(0, indexPath.row - 1),
                                                                    "bookmarkButtonSelected": self.isSelected])
        }
    }
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else { return nil }
        return superView.indexPath(for: self)
    }
    
    func configureData(_ inputData: ArticleDataByWeek) {
        Task {
            let image = try await LHKingFisherService.fetchImage(with: inputData.articleImage)
            articleImageView.image = image
        }
        articleReadTimeLabel.text = "\(inputData.articleReadTime)분 분량"
        articleTitleLabel.text = inputData.articleTitle
        articleTagLabel.text = inputData.articleTags.joined(separator: " · ")
        articleContentLabel.text = inputData.articleContent
        articleContentLabel.setTextWithLineHeight(lineHeight: 22)
        articleContentLabel.lineBreakStrategy = .pushOut
        articleContentLabel.lineBreakMode = .byTruncatingTail
        bookMarkButton.isSelected = inputData.isArticleBookmarked

    }
}
