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
    
    private let backgroundView = LHView(color: .designSystem(.black)?.withAlphaComponent(0.7)).makeRound(4)
    private var weekInfomationLabel = LHLabel(type: .body2R, color: .componentLionRed)
    private var articleTitleLabel = LHLabel(type: .head2, color: .white, lines: 0)
    private var descriptionLabel = LHLabel(type: .body2R, color: .gray400, lines: 3)
    private var weekInfomationView = LHImageView(in: UIImage(named: "today_test_label"), contentMode: .scaleAspectFill)
    var mainArticlImageView = LHImageView(contentMode: .scaleAspectFill).makeRound(4)
    private var seperateLine = LHImageView(in: UIImage(named: "MainArticleSeperateLine"), contentMode: .scaleAspectFill)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(data: TodayArticle?) {
        guard let data else { return }
        Task {
            let image = try await LHKingFisherService.fetchImage(with: data.mainImageURL)
            mainArticlImageView.image = image
        }
        weekInfomationLabel.text = data.currentWeek.description + "주 " + data.currentDay.description + "일차"
        articleTitleLabel.text = data.articleTitle
        descriptionLabel.text = data.articleDescription
        articleTitleLabel.setTextWithLineHeight(lineHeight: 32)
        descriptionLabel.setTextWithLineHeight(lineHeight: 24)
        descriptionLabel.lineBreakMode = .byTruncatingTail

    }
}

private extension TodayArticleView {
    
    func setHierarchy() {
        addSubview(mainArticlImageView)
        mainArticlImageView.addSubviews(backgroundView)
        weekInfomationView.addSubview(weekInfomationLabel)
        backgroundView.addSubviews(descriptionLabel, seperateLine, articleTitleLabel, weekInfomationView)
    }
    
    func setLayout() {
        mainArticlImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        }
        
        weekInfomationLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        weekInfomationLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    

}
