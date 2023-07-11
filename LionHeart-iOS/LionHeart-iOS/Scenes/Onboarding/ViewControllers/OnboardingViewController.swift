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
    
    private var onboardingUser = UserOnboardingModel(pregnacny: 25, fatalNickname: "사랑이")
    
    private var onboardingCompletePercentage: Float = 0 {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.onboardingProgressView.setProgress(self.onboardingCompletePercentage, animated: true)
            }
        }
    }
    
    var fatalNickName: String?
    var pregnancy: Int?
    
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
                onboardingPageViewController.setViewControllers([pageViewControllerDataSource[onboardingFlow.rawValue]], direction: oldValue.rawValue > onboardingFlow.rawValue ? .reverse : .forward, animated: true) { _ in
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
            self.onboardingFlow = self.currentPage.back
            self.onboardingCompletePercentage = self.currentPage.progressValue
        }
    
    private let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .designSystem(.gray600)
        return button
    }()
    
    private let onboardingPageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageViewController
    }()
    
    private var pageViewControllerDataSource: [UIViewController] = OnboardingPageType.allCases.map{ $0.viewController } 
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - 네비게이션바 설정
        setNavigationBar()
        
        // MARK: - autolayout설정
        setLayout()
        
        // MARK: - button의 addtarget설정
        setAddTarget()
        
        // MARK: - delegate설정
        setDelegate()
        
        // MARK: - PageViewController 설정
        setPageViewController()
        
        // MARK: - ProgressView 설정
        setProgressView()
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
        view.addSubview(testButton)
        view.addSubview(onboardingProgressView)
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
            self.onboardingFlow = self.currentPage.forward
            self.onboardingCompletePercentage = self.currentPage.progressValue
        }
    }
    
    func setDelegate() {
    }
    
    func setProgressView() {
        self.onboardingProgressView.setProgress(0.5, animated: false)
    }
}

