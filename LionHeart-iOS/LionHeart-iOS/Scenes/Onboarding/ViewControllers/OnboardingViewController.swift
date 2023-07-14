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
    
    typealias OnboardingViews = [UIViewController]
    
    /// passing data property
    private var fetalNickName: String?
    private var pregnancy: Int?
    private var kakaoAccessToken: String?
    
    /// component property
    private let nextButton = LHOnboardingButton()
    private let onboardingProgressView = LHProgressView()
    private let onboardingViewController = LHOnboardingController()
    private var pageDataSource: OnboardingViews = []
    private lazy var onboardingNavigationbar = LHNavigationBarView(type: .onboarding, viewController: self)
    
    /// onboarding flow property
    private var currentPage: OnboardingPageType = .getPregnancy
    private var onboardingFlow: OnbardingFlowType = .toGetPregnacny {
        didSet {
            switch onboardingFlow {
            case .toLogin:
                presentLoginView()
            case .toGetPregnacny, .toFetalNickname:
                presentOnboardingView(oldValue: onboardingFlow)
            case .toCompleteOnboarding:
                presentCompleteOnboardingView()
            }
        }
    }
    
    private var onboardingCompletePercentage: Float = 0 {
        didSet {
            fillProgressView(from: onboardingCompletePercentage)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setChildViewController()
        setNavigationBar()
        setPageViewController()
        setProgressView()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    func setKakaoAccessToken(_ token: String) {
        self.kakaoAccessToken = token
    }
}

private extension OnboardingViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setNavigationBar() {
        NavigationBarLayoutManager.add(onboardingNavigationbar)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setHierarchy() {
        addChild(onboardingViewController)
        view.addSubviews(onboardingViewController.view, onboardingProgressView, nextButton)
    }
    
    func setPageViewController() {
        if let initalViewController = pageDataSource.first {
            onboardingViewController.setViewControllers([initalViewController], direction: .forward, animated: true)
        }
        onboardingViewController.didMove(toParent: self)
    }
    
    func setLayout() {
        onboardingViewController.view.snp.makeConstraints { make in
            make.top.equalTo(self.onboardingNavigationbar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        
        nextButton.snp.makeConstraints { make in
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
        nextButton.addButtonAction { _ in
            guard let fetalNickName = self.fetalNickName else {
                self.nextOnboardingProcessWithNonActiveButtonState()
                return
            }
            self.nextOnboaringProcess(nickName: fetalNickName, minCount: 1, maxCount: 10)
        }
        
        onboardingNavigationbar.backButtonAction {
            self.backOnboardingProcess()
        }
    }
    
    func setChildViewController() {
        let pregnancyViewController = GetPregnancyViewController()
        pregnancyViewController.delegate = self
        pageDataSource.append(pregnancyViewController)
        let fetalNicknameViewController = GetFetalNicknameViewController()
        fetalNicknameViewController.delegate = self
        pageDataSource.append(fetalNicknameViewController)
    }
    
    func setProgressView() {
        self.onboardingProgressView.setProgress(0.5, animated: false)
    }
}

private extension OnboardingViewController {
    func fillProgressView(from input: Float) {
        UIView.animate(withDuration: 0.2) {
            self.onboardingProgressView.setProgress(input, animated: true)
        }
    }

    func presentLoginView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func presentOnboardingView(oldValue: OnbardingFlowType) {
        onboardingViewController.setViewControllers([pageDataSource[onboardingFlow.rawValue]],
                                                    direction: oldValue.rawValue > onboardingFlow.rawValue ? .reverse : .forward,
                                                        animated: false) { _ in
            guard let currentPage = OnboardingPageType(rawValue: self.onboardingFlow.rawValue) else { return }
            self.currentPage = currentPage
        }
    }
    
    func presentCompleteOnboardingView() {
        let completeViewController = CompleteOnbardingViewController()
        let passingData = UserOnboardingModel(kakaoAccessToken: "카카오어세스토큰", pregnacny: self.pregnancy, fetalNickname: self.fetalNickName)
        completeViewController.userData = passingData
        self.navigationController?.pushViewController(completeViewController, animated: true)
    }
}

private extension OnboardingViewController {
    func nextOnboaringProcess(nickName: String, minCount: Int, maxCount: Int) {
        self.nextButton.isHidden = nickName.count >= minCount && nickName.count <= maxCount ? false : true
        self.onboardingFlow = self.currentPage.forward
        self.onboardingCompletePercentage = self.currentPage.progressValue
    }
    
    func nextOnboardingProcessWithNonActiveButtonState() {
        self.nextButton.isHidden = true
        self.onboardingFlow = self.currentPage.forward
        self.onboardingCompletePercentage = self.currentPage.progressValue
    }
    
    func backOnboardingProcess() {
        self.view.endEditing(true)
        self.nextButton.isHidden = false
        self.onboardingFlow = self.currentPage.back
        self.onboardingCompletePercentage = self.currentPage.progressValue
    }
}

extension OnboardingViewController: FetalNicknameCheckDelegate {
    func sendFetalNickname(nickName: String) {
        self.fetalNickName = nickName
    }
    
    func checkFetalNickname(resultType: OnboardingFetalNicknameTextFieldResultType) {
        nextButton.isHidden = resultType.isHidden
    }
}

extension OnboardingViewController: PregnancyCheckDelegate {
    func sendPregnancyContent(pregnancy: Int) {
        self.pregnancy = pregnancy
    }
    
    func checkPregnancy(resultType: OnboardingPregnancyTextFieldResultType) {
        nextButton.isHidden = resultType.isHidden
    }
}
