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
    
    private var onboardingCompletePercentage: Float = 0 {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.onboardingProgressView.setProgress(self.onboardingCompletePercentage, animated: true)
            }
        }
    }
    
    private var fatalNickName: String?
    private var pregnancy: Int?
    
    private var onboardingProgressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressViewStyle = .bar
        progress.progressTintColor = .designSystem(.lionRed)
        progress.backgroundColor = .designSystem(.gray800)
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        progress.progress = 0
        return progress
    }()
    
    private var currentPage: OnboardingPageType = .getPregnancy
    
    private var onboardingFlow: OnbardingFlowType = .toGetPregnacny {
        didSet {
            switch onboardingFlow {
            case .toLogin:
                self.navigationController?.popViewController(animated: true)
                
            case .toGetPregnacny, .toFatalNickname:
                onboardingPageViewController.setViewControllers([pageViewControllerDataSource[onboardingFlow.rawValue]],
                                                                direction: oldValue.rawValue > onboardingFlow.rawValue ? .reverse : .forward,
                                                                animated: false) { _ in
                    guard let currentPageType = OnboardingPageType(rawValue: self.onboardingFlow.rawValue) else { return }
                    self.currentPage = currentPageType
                }
                
            case .toCompleteOnboarding:
                let completeViewController = CompleteOnbardingViewController()
                let passingData = UserOnboardingModel(pregnacny: self.pregnancy, fatalNickname: self.fatalNickName)
                completeViewController.userData = passingData
                self.navigationController?.pushViewController(completeViewController, animated: true)
            }
        }
    }
    
    private lazy var onboardingNavigationbar = LHNavigationBarView(type: .onboarding, viewController: self)
        .backButtonAction {
            self.view.endEditing(true)
            self.testButton.isHidden = false
            self.onboardingFlow = self.currentPage.back
            self.onboardingCompletePercentage = self.currentPage.progressValue
        }
    
    private let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .designSystem(.lionRed)
        button.isHidden = true
        return button
    }()
    
    private let onboardingPageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageViewController
    }()
    
    private var pageViewControllerDataSource: [UIViewController] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        
        setChildViewController()
        
        // MARK: - 네비게이션바 설정
        setNavigationBar()
        
        // MARK: - PageViewController 설정
        setPageViewController()
        
        // MARK: - ProgressView 설정
        setProgressView()
        
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
        view.backgroundColor = .designSystem(.background)
    }
    
    func setNavigationBar() {
        NavigationBarLayoutManager.add(onboardingNavigationbar)
    }
    
    func setHierarchy() {
        addChild(onboardingPageViewController)
        view.addSubview(onboardingPageViewController.view)
        view.addSubview(onboardingProgressView)
        view.addSubview(testButton)
    }
    
    func setPageViewController() {
        if let firstViewController = pageViewControllerDataSource.first {
            onboardingPageViewController.setViewControllers([firstViewController], direction: .forward, animated: true)
        }
        onboardingPageViewController.didMove(toParent: self)
    }
    
    func setLayout() {
        onboardingPageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(self.onboardingNavigationbar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(testButton.snp.top)
        }
        
        
        testButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        onboardingProgressView.snp.makeConstraints { make in
            make.top.equalTo(self.onboardingNavigationbar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setAddTarget() {
        testButton.addButtonAction { _ in
            guard let fatalNickName = self.fatalNickName else {
                self.testButton.isHidden = true
                self.onboardingFlow = self.currentPage.forward
                self.onboardingCompletePercentage = self.currentPage.progressValue
                return
            }
            if fatalNickName.count >= 1 && fatalNickName.count <= 10 {
                self.testButton.isHidden = false
            } else {
                self.testButton.isHidden = true
            }
            
            self.onboardingFlow = self.currentPage.forward
            self.onboardingCompletePercentage = self.currentPage.progressValue
        }
    }
    
    func setDelegate() {
    }
    
    func setChildViewController() {
        let pregnancyViewController = GetPregnancyViewController()
        pregnancyViewController.delegate = self
        pageViewControllerDataSource.append(pregnancyViewController)
        let fatalNicknameViewController = GetFatalNicknameViewController()
        fatalNicknameViewController.delegate = self
        pageViewControllerDataSource.append(fatalNicknameViewController)
    }
    
    func setProgressView() {
        self.onboardingProgressView.setProgress(0.5, animated: false)
    }
}

extension OnboardingViewController: FatalNicknameCheckDelegate {
    func sendFatalNickname(nickName: String) {
        self.fatalNickName = nickName
    }
    
    func checkFatalNickname(resultType: OnboardingFatalNicknameTextFieldResultType) {
        switch resultType {
        case .fatalNicknameTextFieldEmpty:
            testButton.isHidden = true
        case .fatalNicknameTextFieldOver:
            testButton.isHidden = true
        case .fatalNicknameTextFieldValid:
            testButton.isHidden = false
        }
    }
}

extension OnboardingViewController: PregnancyCheckDelegate {
    func sendPregnancyContent(pregnancy: Int) {
        self.pregnancy = pregnancy
    }
    
    func checkPregnancy(resultType: OnboardingPregnancyTextFieldResultType) {
        switch resultType {
        case .pregnancyTextFieldEmpty:
            testButton.isHidden = true
        case .pregnancyTextFieldValid:
            testButton.isHidden = false
        case .pregnancyTextFieldOver:
            testButton.isHidden = true
        }
    }
}
