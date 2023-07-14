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
    
    private var todayArticleData = TodayArticle.dummy

    private lazy var todayNavigationBar = LHNavigationBarView(type: .today, viewController: self)
    private let seperateLine: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray800)
        return view
    }()
    private var titleLabel = LHTodayArticleTitle(nickName: "사랑이")
    private var mainArticleView = TodayArticleView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
        setHierarchy()
        setLayout()
        setTapGesture()
        setData()
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
        view.addSubviews(todayNavigationBar, seperateLine)
        view.addSubviews(titleLabel, mainArticleView)
        
    }
    
    func setLayout() {
        todayNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        seperateLine.snp.makeConstraints { make in
            make.top.equalTo(todayNavigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(seperateLine.snp.bottom).offset(53)
            make.leading.equalToSuperview().inset(20)
        }
        
        mainArticleView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.width.equalTo(ScreenUtils.getWidth(335))
            make.centerX.equalToSuperview()
            make.height.equalTo(mainArticleView.snp.width).multipliedBy(TodayArticleImage.ratio)
        }
    }
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(articleTapped(_:)))
        mainArticleView.addGestureRecognizer(tapGesture)
    }
    
    func setData() {
        mainArticleView.data = todayArticleData
    }
    
    @objc func articleTapped(_ sender: UIButton) {
        let articleDetailViewController = ArticleDetailViewController()
        self.navigationController?.pushViewController(articleDetailViewController, animated: true)
    }
}
