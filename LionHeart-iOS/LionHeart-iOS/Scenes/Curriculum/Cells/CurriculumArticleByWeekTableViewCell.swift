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
            
            articleDayLabel.text = inputData?.articleDay
            articleTagLabel.text = inputData?.articleTags
            articleReadTimeLabel.text = inputData?.articleReadTime
            articleDateLabel.text = inputData?.articleDate
            articleContentLabel.text = inputData?.articleContent
            
        }
    }
    
    private let tableViewCellWholeView = UIView()

    private enum Size {
        static let readTimeAndBookmarkViewSize: CGFloat = 44 / 335
        static let articleImageSize: CGFloat = 200 / 335

    }
    
    private let articleDayLabel: UILabel = {
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
    
    private let articleDateLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.gray600)
        return label
    }()
    
    private let articleContentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray300)
        return label
    }()
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.ArticleCategory.coupleCategory
        imageView.layer.opacity = 0.4
        return imageView
    }()
    
    private let readTimeAndBookmarkView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.layer.opacity = 0.6
        return view
    }()
    
    private lazy var bookMarkButton: UIButton = {
        var button = UIButton()
        button.setImage(ImageLiterals.BookMark.inactiveBookmarkSmall, for: .normal)
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

private extension CurriculumArticleByWeekTableViewCell {
    func setUI() {
        
    }
    
    func setHierarchy() {
        readTimeAndBookmarkView.addSubviews(articleReadTimeLabel, bookMarkButton)
        tableViewCellWholeView.addSubviews(readTimeAndBookmarkView, articleImageView, articleTagLabel, articleDateLabel, articleDayLabel, articleContentLabel)
        
        contentView.addSubviews(tableViewCellWholeView)
    }
    
    func setLayout() {
        
        articleReadTimeLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(13)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalTo(articleImageView.snp.top).offset(-13)
            
        }
        
        bookMarkButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(4)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        readTimeAndBookmarkView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        articleImageView.snp.makeConstraints{
            $0.top.equalTo(articleReadTimeLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(articleImageView.snp.width).multipliedBy(Size.articleImageSize)
        }
        
        tableViewCellWholeView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(36)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        articleTagLabel.snp.makeConstraints{
            $0.top.equalTo(articleImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        articleDateLabel.snp.makeConstraints{
            $0.top.equalTo(articleImageView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview()
        }
        
        articleDayLabel.snp.makeConstraints{
            $0.top.equalTo(articleTagLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        
        articleContentLabel.snp.makeConstraints{
            $0.top.equalTo(articleDayLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
}
