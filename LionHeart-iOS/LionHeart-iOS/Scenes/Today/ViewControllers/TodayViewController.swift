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
    
    enum Ratio {
        static let imageRatio: CGFloat = 400/335
    }

    
    private lazy var todayNavigationBar = LHNavigationBarView(type: .today, viewController: self)
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head1)
        label.textColor = .designSystem(.white)
        label.numberOfLines = 2
        label.text = "사랑이 아빠님,\n오늘의 아티클이에요"
        return label
    }()
    
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
        
        // MARK: - button의 addtarget설정
        setAddTarget()
        
        // MARK: - delegate설정
        setDelegate()
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
            make.height.equalTo(mainArticlImageView.snp.width).multipliedBy(Ratio.imageRatio)
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
}
