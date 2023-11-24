//
//  ArticleCategoryViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 ArticleCategory. All rights reserved.
//

import UIKit
import Combine

import SnapKit

protocol ArticleCategoryViewControllerable where Self: UIViewController {}

final class ArticleCategoryViewController: UIViewController, ArticleCategoryViewControllerable {
    
    private lazy var navigationBar = LHNavigationBarView(type: .explore, viewController: self)
    private lazy var titleLabel = LHLabel(type: .head2, color: .white, lines: 2, basicText: "카테고리별\n아티클 모아보기")
    private lazy var subtitleLabel = LHLabel(type: .body3R, color: .gray400, basicText: "똑똑한 아빠들의 비밀 습관")
    private lazy var categoryArticleCollectionView = LHCollectionView(color: .background)
    
    private var datasource: UICollectionViewDiffableDataSource<ArticleCategorySection, ArticleCategoryItem>!

    private let viewModel: any ArticleCategoryViewModel
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let bookMarkButtonTapped = PassthroughSubject<Void, Never>()
    private let myPageButtonTapped = PassthroughSubject<Void, Never>()
    private let categoryCellTapped = PassthroughSubject<IndexPath, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setNavigation()
        setLayout()
        setDelegate()
        setCollectionView()
        bindInput()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showLoading()
        viewWillAppearSubject.send(())
    }
    
    init(viewModel: some ArticleCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindInput() {
        navigationBar.rightFirstBarItem.tapPublisher
            .sink { [weak self] _ in
                self?.bookMarkButtonTapped.send(())
            }
            .store(in: &cancelBag)
        
        navigationBar.rightSecondBarItem.tapPublisher
            .sink { [weak self] _ in
                self?.myPageButtonTapped.send(())
            }
            .store(in: &cancelBag)
    }
    
    func bind() {
        let input = ArticleCategoryViewModelInput(
            viewWillAppear: viewWillAppearSubject,
            bookMarkButtonTapped: bookMarkButtonTapped,
            myPageButtonTapped: myPageButtonTapped,
            categoryCellTapped: categoryCellTapped)
        let output = viewModel.transform(input: input)
        
        output.categoryTitle
            .receive(on: RunLoop.main)
            .sink { [weak self] categoryImages in
                guard let self else { return }
                self.setDataSource()
                self.applySnapshot(categoryImages: categoryImages)
                self.hideLoading()
            }
            .store(in: &cancelBag)
    }
    
    private func setDataSource() {
        self.datasource = ArticleCategoryDiffableDataSource(collectionView: self.categoryArticleCollectionView)
    }
    
    private func applySnapshot(categoryImages: [CategoryImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<ArticleCategorySection, ArticleCategoryItem>()
        snapshot.appendSections([.articleCategory])
        
        let items = categoryImages.map {
            return ArticleCategoryItem.category(title: $0)
        }
        
        snapshot.appendItems(items, toSection: .articleCategory)
        self.datasource.apply(snapshot)
    }
    
}

private extension ArticleCategoryViewController {
    
    enum Size {
        static let cellOffset: CGFloat = 51
        static let numberOfCellsinRow: CGFloat = 2
        static let imageWidth: CGFloat = 162
        static let imageHeight: CGFloat = 112
    }
    
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(titleLabel, navigationBar, titleLabel, subtitleLabel, categoryArticleCollectionView)
    }
    
    func setLayout() {

         titleLabel.snp.makeConstraints { make in
             make.top.equalTo(navigationBar.snp.bottom).offset(28)
             make.leading.equalToSuperview().inset(20)
         }
         subtitleLabel.snp.makeConstraints { make in
             make.top.equalTo(titleLabel.snp.bottom).offset(10)
             make.leading.equalToSuperview().inset(20)
         }
         categoryArticleCollectionView.snp.makeConstraints { make in
             make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
             make.leading.trailing.equalToSuperview()
             make.bottom.equalToSuperview().inset(100)
         }
    }
    
    func setDelegate() {
        categoryArticleCollectionView.delegate = self
    }
    
    func setNavigation() {
        self.navigationController?.isNavigationBarHidden = true
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setCollectionView() {
        ArticleCategoryCollectionViewCell.register(to: categoryArticleCollectionView)
    }
}

extension ArticleCategoryViewController: UICollectionViewDelegate {
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryCellTapped.send(indexPath)
    }
}

extension ArticleCategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 80, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (Constant.Screen.width - Size.cellOffset) / Size.numberOfCellsinRow
        let height = width * (Size.imageHeight/Size.imageWidth)
        return CGSize(width: width, height: height)
    }
}
