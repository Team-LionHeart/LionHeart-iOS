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
    
    private var mainArticlImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "today_test_image")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var weekInfomationView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "today_test_label"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var weekInfomationLabel: UILabel = {
        let label = UILabel()
        label.text = "27주 6일차"
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.componentLionRed)
        return label
    }()
    
    private var articleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "출산카드 신청하기\nA to Z"
        label.textColor = .designSystem(.white)
        label.font = .pretendard(.head2)
        label.numberOfLines = 0
        return label
    }()
    
    private var seperateLine: UIView = {
        let view = UIView()
        return view
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "젖병을 잘못 구매하면, 배앓이를 한다는 말 들어\n보셨나요? 오늘은 신생아에게 가장 중요한 젖병\n이야기를 들려드릴게요."
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.gray400)
        label.setTextWithLineHeight(lineHeight: 24)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setHierarchy()
        setLayout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        seperateLine.setGradient(firstColor: .designSystem(.gray400)!, secondColor: .designSystem(.gray600)!.withAlphaComponent(0))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TodayArticleView {
    func setUI() {
        
    }
    
    func setHierarchy() {
        addSubview(mainArticlImageView)
        weekInfomationView.addSubview(weekInfomationLabel)
        mainArticlImageView.addSubviews(descriptionLabel, seperateLine, articleTitleLabel, weekInfomationView)
    }
    
    func setLayout() {
        mainArticlImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        weekInfomationLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(16)
        }
        
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
            make.height.equalTo(40)
            make.width.equalTo(110)
        }
    }
}
