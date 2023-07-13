//
//  TodayViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Today. All rights reserved.
//

import UIKit

import SnapKit

final class TodayViewController: UIViewController {
    
    enum TodayArticleImage {
        static let ratio: CGFloat = 400/335
    }

    private lazy var todayNavigationBar = LHNavigationBarView(type: .today, viewController: self)
    private var titleLabel = LHTodayArticleTitle(nickName: "사랑이")
    private var mainArticlImageView = TodayArticleView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        
        setNavigationBar()
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - autolayout설정
        setLayout()
        
        setTapGesture()
    }
}

private extension TodayViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.black)
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubview(todayNavigationBar)
        view.addSubviews(titleLabel, mainArticlImageView)
    }
    
    func setLayout() {
        todayNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(todayNavigationBar.snp.bottom).offset(53)
            make.leading.equalToSuperview().inset(20)
        }
        
        mainArticlImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.width.equalTo(ScreenUtils.getWidth(335))
            make.centerX.equalToSuperview()
            make.height.equalTo(mainArticlImageView.snp.width).multipliedBy(TodayArticleImage.ratio)
        }
    }
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(articleTapped(_:)))
        mainArticlImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func articleTapped(_ sender: UIButton) {
        let articleDetailViewController = ArticleDetailViewController()
        self.navigationController?.pushViewController(articleDetailViewController, animated: true)
    }
}
