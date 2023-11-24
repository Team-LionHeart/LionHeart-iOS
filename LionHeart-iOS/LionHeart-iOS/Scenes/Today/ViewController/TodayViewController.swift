//
//  TodayViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Today. All rights reserved.
//

import UIKit
import Combine

import SnapKit

protocol TodayViewControllerable where Self: UIViewController {}

final class TodayViewController: UIViewController, TodayViewControllerable {
    
    private lazy var todayNavigationBar = LHNavigationBarView(type: .today, viewController: self)
    private var titleLabel = LHTodayArticleTitle()
    private var subTitleLable = LHTodayArticleTitle(initalizeString: "오늘의 아티클이에요")
    private var mainArticleView = TodayArticleView()
    private var pointImage = LHImageView(in: UIImage(named: "TodayArticle_PointImage"), contentMode: .scaleAspectFit)
    
    private let viewModel: any TodayViewModel
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let navigationLeftButtonTapped = PassthroughSubject<Void, Never>()
    private let navigationRightButtonTapped = PassthroughSubject<Void, Never>()
    private let todayArticleTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    init(viewModel: some TodayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
        setHierarchy()
        setLayout()
        bindInput()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showLoading()
        self.viewWillAppearSubject.send(())
    }
    
    func bindInput() {
        self.todayNavigationBar.rightFirstBarItem.tapPublisher
            .sink { [weak self] in self?.navigationLeftButtonTapped.send(()) }
            .store(in: &cancelBag)
        
        self.todayNavigationBar.rightSecondBarItem.tapPublisher
            .sink { [weak self] in self?.navigationRightButtonTapped.send(()) }
            .store(in: &cancelBag)
        
        self.mainArticleView.tabPublisher
            .sink { [weak self] in self?.todayArticleTapped.send(()) }
            .store(in: &cancelBag)
    }
    
    func bind() {
        let input = TodayViewModelInput(viewWillAppearSubject: viewWillAppearSubject, navigationLeftButtonTapped: navigationLeftButtonTapped, navigationRightButtonTapped: navigationRightButtonTapped, todayArticleTapped: todayArticleTapped)
        let output = viewModel.transform(input: input)
        output.viewWillAppearSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.mainArticleView.configureView(data: $0)
                self?.hideLoading()
            }
            .store(in: &cancelBag)
    }
}

private extension TodayViewController {
    enum TodayArticleImage {
        static let ratio: CGFloat = 400/335
    }
    
    func setUI() {
        view.backgroundColor = .designSystem(.black)
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(todayNavigationBar)
        view.addSubviews(titleLabel, subTitleLable, pointImage, mainArticleView)
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
        
        subTitleLable.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        pointImage.snp.makeConstraints { make in
            make.top.equalTo(subTitleLable.snp.top)
            make.leading.equalTo(subTitleLable.snp.trailing).offset(4)
            make.size.equalTo(10)
        }
        
        mainArticleView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLable.snp.bottom).offset(28)
            make.width.equalTo(ScreenUtils.getWidth(335))
            make.centerX.equalToSuperview()
            make.height.equalTo(mainArticleView.snp.width).multipliedBy(TodayArticleImage.ratio)
        }
    }
}
