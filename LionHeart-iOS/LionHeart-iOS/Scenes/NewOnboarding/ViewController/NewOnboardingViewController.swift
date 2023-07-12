//
//  NewOnboardingViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/12.
//  Copyright (c) 2023 NewOnboarding. All rights reserved.
//

import UIKit

import SnapKit

final class NewOnboardingViewController: UIViewController {
    
    var currentPage: OnboardingPageType = .getPregnancy
    
    var onboardingFlow: OnbardingFlowType = .toFatalNickname {
        didSet {
            switch onboardingFlow {
            case .toGetPregnacny:
                onboardingCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: oldValue.rawValue > onboardingFlow.rawValue ? .left : .right, animated: false)
                
                
            case .toFatalNickname:
                onboardingCollectionView.scrollToItem(at: .init(item: 1, section: 0), at: oldValue.rawValue > onboardingFlow.rawValue ? .left : .right, animated: false)
            case .toLogin:
                self.navigationController?.popViewController(animated: true)
            case .toCompleteOnboarding:
                let completeViewController = CompleteOnbardingViewController()
                self.navigationController?.pushViewController(completeViewController, animated: true)
            }
        }
    }
 
    private lazy var onboardingNavigationbar = LHNavigationBarView(type: .onboarding, viewController: self)
        .backButtonAction {
            self.onboardingFlow = self.currentPage.back // scroll to 임신주차 설정 뷰
            guard let currentPageType = OnboardingPageType(rawValue: self.onboardingFlow.rawValue) else { return }
            self.currentPage = currentPageType
        }
    
    private var onboardingProgressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressViewStyle = .bar
        progress.progressTintColor = .designSystem(.lionRed)
        progress.backgroundColor = .designSystem(.gray800)
        progress.transform = progress.transform.scaledBy(x: 1, y: 3)
        progress.progress = 0
        return progress
    }()
    
    private let onboardingCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .designSystem(.gray600)
        return button
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - addsubView
        setHierarchy()
        
        setNavigationBar()
        
        // MARK: - autolayout설정
        setLayout()
        
        // MARK: - button의 addtarget설정
        setAddTarget()
        
        // MARK: - delegate설정
        setDelegate()
        
        setProgressView()
    }
    
    
}

private extension NewOnboardingViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(onboardingProgressView, onboardingCollectionView, testButton)
    }
    
    func setLayout() {
        onboardingProgressView.snp.makeConstraints { make in
            make.top.equalTo(self.onboardingNavigationbar.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        onboardingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(onboardingProgressView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(368)
        }
        

    }
    
    func setAddTarget() {
        testButton.addButtonAction { sender in
            self.onboardingFlow = self.currentPage.forward 
            guard let currentPageType = OnboardingPageType(rawValue: self.onboardingFlow.rawValue) else { return }
            self.currentPage = currentPageType
        }
    }
    
    func setDelegate() {
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.delegate = self
        PregnancyCollectionViewCell.register(to: onboardingCollectionView)
        FetusNameCollectionViewCell.register(to: onboardingCollectionView)
    }
    
    func setNavigationBar() {
        NavigationBarLayoutManager.add(onboardingNavigationbar)
    }
    
    func setProgressView() {
        self.onboardingProgressView.setProgress(0.5, animated: false)
    }
}

extension NewOnboardingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = PregnancyCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.isFocusted.toggle()
            return cell
        case 1:
            let cell = FetusNameCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.isFocusted.toggle()
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
}

extension NewOnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: Constant.Screen.width, height: 368)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
