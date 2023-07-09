//
//  TabBarViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 TabBar. All rights reserved.
//

import UIKit

import SnapKit

final class TabBarViewController: UITabBarController {
    

    public override func viewDidLoad() {
        super.viewDidLoad()
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
}

private extension TabBarViewController {
    func setUI() {
        
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
