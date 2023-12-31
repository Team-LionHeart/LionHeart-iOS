//
//  OnboardingViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Onboarding. All rights reserved.
//

import UIKit
import Combine

import SnapKit

protocol OnboardingViewControllerable where Self: UIViewController {}

final class OnboardingViewController: UIViewController, OnboardingViewControllerable {
    typealias OnboardingViews = [UIViewController]

    private let pregenacy = CurrentValueSubject<(pregnancy: Int, isValid: Bool), Never>((pregnancy: 0, isValid: true))
    private let fetalNickname = CurrentValueSubject<(fetalNickname: String, isValid: Bool), Never>((fetalNickname: "", isValid: true))
    private let backButtonTapped = PassthroughSubject<Void, Never>()
    private let nextButtonTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private let nextButton = LHOnboardingButton()
    private let onboardingProgressView = LHProgressView()
    private let onboardingViewController = LHOnboardingPageViewController()
    private var pageDataSource: OnboardingViews = []
    private lazy var onboardingNavigationbar = LHNavigationBarView(type: .onboarding, viewController: self)
    private var viewModel: any OnboardingViewModel

    init(viewModel: some OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        bindInput()
        bind()
    }
    
    func bindInput() {
        nextButton.tapPublisher
            .sink { [weak self] in self?.nextButtonTapped.send(()) }
            .store(in: &cancelBag)
        
        onboardingNavigationbar.leftBarItem.tapPublisher
            .sink { [weak self] in self?.backButtonTapped.send(()) }
            .store(in: &cancelBag)
    }
    
    func bind() {
        let input = OnboardingViewModelInput(pregenacy: pregenacy, fetalNickname: fetalNickname, backButtonTapped: backButtonTapped, nextButtonTapped: nextButtonTapped)
        let output = viewModel.transform(input: input)
        
        output.userSigningSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                $0 ? self?.hideLoading() : self?.showLoading()
            }
            .store(in: &cancelBag)
        
        output.fetalButtonState
            .receive(on: RunLoop.main)
            .sink { [ weak self ] in self?.nextButton.isHidden = $0 }
            .store(in: &cancelBag)
        
        output.pregenacyButtonState
            .receive(on: RunLoop.main)
            .sink { [ weak self ] in self?.nextButton.isHidden = $0 }
            .store(in: &cancelBag)
        
        output.onboardingFlow
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                if $0 == .toCompleteOnboarding {
                    self?.nextButton.isUserInteractionEnabled = false
                }
                self?.nextButton.isHidden = true
                self?.presentOnboardingView()
                self?.fillProgressView(from: 1)
            }
            .store(in: &cancelBag)
        
        output.signUpSubject
            .sink { errorMessage in
                print(errorMessage)
            }
            .store(in: &cancelBag)
    }
}

private extension OnboardingViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setHierarchy() {
        addChild(onboardingViewController)
        view.addSubviews(onboardingViewController.view, onboardingNavigationbar, onboardingProgressView, nextButton)
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
        
        onboardingNavigationbar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
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

    func setChildViewController() {
        let pregnancyViewController = GetPregnancyViewController(viewModel: GetPregnancyViewModelImpl())
        pregnancyViewController.pregnancyIsValid
            .sink { [weak self] in self?.pregenacy.send($0) }
            .store(in: &cancelBag)
        pageDataSource.append(pregnancyViewController)
        let fetalNicknameViewController = GetFetalNicknameViewController(viewModel: GetFetalNicknameViewModelImpl())
        fetalNicknameViewController.fetalIsValid
            .sink { [weak self] in self?.fetalNickname.send($0) }
            .store(in: &cancelBag)
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
    
    func presentOnboardingView(newValue: OnbardingFlowType = .toFetalNickname) {
        onboardingViewController.setViewControllers([pageDataSource[newValue.rawValue]], direction: .forward, animated: false)
    }
}
