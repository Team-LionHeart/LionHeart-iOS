//
//  TodayArticleView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Today. All rights reserved.
//

import UIKit

import SnapKit

final class TodayArticleView: UIView {
    
    var data: TodayArticle? {
        didSet {
            configureView(data: data)
        }
    }
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.black)?.withAlphaComponent(0.2)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    var mainArticlImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var weekInfomationView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "today_test_label"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var weekInfomationLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.componentLionRed)
        return label
    }()
    
    private var articleTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .pretendard(.head2)
        label.numberOfLines = 0
        return label
    }()
    
    private var seperateLine: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "MainArticleSeperateLine"))
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.gray400)
        label.numberOfLines = 3
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setLayout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        mainArticlImageView.setGradient(firstColor: .designSystem(.black)!.withAlphaComponent(0.2), secondColor: .designSystem(.gray1000)!, axis: .vertical)
        
        weekInfomationView.addSubview(weekInfomationLabel)
        
        mainArticlImageView.addSubviews(descriptionLabel, seperateLine, articleTitleLabel, weekInfomationView)
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(36)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        seperateLine.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        articleTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(seperateLine.snp.top).offset(-12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        weekInfomationView.snp.makeConstraints { make in
            make.bottom.equalTo(articleTitleLabel.snp.top).offset(-12)
            make.leading.equalToSuperview()
        }
        
        weekInfomationLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        weekInfomationLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TodayArticleView {
    
    func setHierarchy() {
        addSubview(mainArticlImageView)
        mainArticlImageView.addSubviews(backgroundView)
    }
    
    func setLayout() {
        
        mainArticlImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureView(data: TodayArticle?) {
        guard let data else { return }
        weekInfomationLabel.text = data.currentWeek.description + "주 " + data.currentDay.description + "일차"
        articleTitleLabel.text = data.articleTitle
        descriptionLabel.text = data.articleDescription
        articleTitleLabel.setTextWithLineHeight(lineHeight: 32)
        descriptionLabel.setTextWithLineHeight(lineHeight: 24)
        /// 얘도 text가 있을때 적용되는 녀석
        descriptionLabel.lineBreakMode = .byTruncatingTail
    }
}
