//
//  OnboardingViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Onboarding. All rights reserved.
//

import UIKit

import SnapKit

final class OnboardingViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - 네비게이션바 설정
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

private extension OnboardingViewController {
    func setUI() {
        
    }
    
    func setNavigationBar() {
        let onboardingNavigationbar = LHNavigationBarView(type: .onboarding, viewController: self)
            .rightFirstBarItemAction {
                self.navigationController?.popViewController(animated: true)
            }
        NavigationBarLayoutManager.add(onboardingNavigationbar)
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
