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
    
    private var mainArticlImageView: UIImageView = {
        let imageView = UIImageView()
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
    
    private var seperateLine: UIView = {
        let view = UIView()
        return view
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
        
        weekInfomationLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
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
        }
    }
    
    func configureView(data: TodayArticle?) {
        guard let data else { return }
        weekInfomationLabel.text = data.currentWeek.description + "주 " + data.currentDay.description + "일차"
        articleTitleLabel.text = data.articleTitle
        articleTitleLabel.setTextWithLineHeight(lineHeight: 32)
        descriptionLabel.text = data.articleDescription
        descriptionLabel.setTextWithLineHeight(lineHeight: 24)
        Task {
            do {
                let image = try await LHKingFisherService.fetchImage(with: data.mainImageURL)
                mainArticlImageView.image = image
            } catch {
                print(error)
            }
        }
    }
}
