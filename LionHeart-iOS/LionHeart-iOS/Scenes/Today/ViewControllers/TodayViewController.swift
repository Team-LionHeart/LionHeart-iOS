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
    
    private lazy var todayNavigationBar = LHNavigationBarView(type: .today, viewController: self)
    

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
    
    /// gradient 설정해주기 life cycle고려해야함
    override func viewDidLayoutSubviews() {
    }
}

private extension TodayViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setNavigationBar() {
        NavigationBarLayoutManager.add(todayNavigationBar)
    }
    
    func setHierarchy() {
        
    }
    
    func setLayout() {
        
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
}
