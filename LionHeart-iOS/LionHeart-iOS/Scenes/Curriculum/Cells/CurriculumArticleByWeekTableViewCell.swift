//
//  CurriculumArticleByWeekTableViewCell.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/14.
//  Copyright (c) 2023 CurriculumArticleByWeek. All rights reserved.
//

import UIKit

import SnapKit

struct BookmarkButtonTapped{
    
}

final class CurriculumArticleByWeekTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {
    
    var isBookmarkedIndexPath: IndexPath?
    
    var inputData: ArticleDataByWeek? {
        didSet {
            guard let inputData else {
                return
            }
            articleReadTimeLabel.text = "\(inputData.articleReadTime)분 분량"
            articleTitleLabel.text = inputData.articleTitle
            Task {
                let image = try await LHKingFisherService.fetchImage(with: inputData.articleImage)
                articleImageView.image = image
            }
            articleTagLabel.text = inputData.articleTags.joined(separator: " · ")
            articleContentLabel.text = inputData.articleContent
            articleContentLabel.lineBreakStrategy = .pushOut
            articleContentLabel.lineBreakMode = .byTruncatingTail
            
        }
    }
    
    private let tableViewCellWholeView = UIView()
    
    private enum Size {
        static let readTimeAndBookmarkViewSize: CGFloat = 44 / 335
        static let articleImageSize: CGFloat = 200 / 335
        
    }
    
    private let articleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head3)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    private let articleTagLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.gray400)
        return label
    }()
    
    private let articleReadTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.gray500)
        return label
    }()
    
    private let articleContentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray300)
        label.numberOfLines = 2
        return label
    }()
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.opacity = 0.4
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private let readTimeAndBookmarkView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.backgroundColor = .designSystem(.black)
        view.layer.opacity = 0.6
        return view
    }()
    
    private lazy var bookMarkButton: UIButton = {
        var button = UIButton()
        button.setImage(ImageLiterals.BookMark.inactiveBookmarkSmall, for: .normal)
        button.setImage(ImageLiterals.BookMark.activeBookmarkSmall, for: .selected)
        button.addButtonAction { _ in
            
            // VC로 넘기기 노티피케이션
            NotificationCenter.default.post(name: NSNotification.Name("isArticleBookmarked"),
                                            object: nil, userInfo: ["bookmarkCellIndexPath": self.isBookmarkedIndexPath?.row ?? 0,
                                                                    "bookmarkButtonSelected": !button.isSelected])
            button.isSelected.toggle()
        }
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // MARK: - 컴포넌트 설정
        setUI()
        
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

private extension CurriculumArticleByWeekTableViewCell {
    func setUI() {
        contentView.backgroundColor = .designSystem(.background)
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
}
