//
//  ArticleCategoryViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 ArticleCategory. All rights reserved.
//

import UIKit

import SnapKit

final class ArticleCategoryViewController: UIViewController {
    
    private enum Size {
        static let cellOffset: CGFloat = 51
        static let edgesOffset: CGFloat = 2
    }
    
    private lazy var navigationBar = LHNavigationBarView(type: .explore, viewController: self)
    
    private var dummyCase = CategoryImage.dummy() {
        didSet {
            self.categoryArticleCollectionView.reloadData()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어제보다 오늘,\n더 좋은 아빠가 되어볼까요?"
        label.numberOfLines = 2
        label.font = .pretendard(.head2)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "똑똑한 아빠들의 비밀 습관"
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray400)
        return label
    }()
    
    lazy var categoryArticleCollectionLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리별 아티클 모아보기"
        label.font = .pretendard(.head3)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.background)
        return view
    }()
    
    lazy var categoryArticleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .designSystem(.background)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

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
        
        setNavigation()
    }
}

private extension ArticleCategoryViewController {
    func setUI() {
        ArticleCategoryCollectionViewCell.register(to: categoryArticleCollectionView)
        view.backgroundColor = .designSystem(.background)
        categoryArticleCollectionView.delegate = self
        categoryArticleCollectionView.dataSource = self
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, titleLabel, subtitleLabel, categoryArticleCollectionLabel, categoryArticleCollectionView)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(28)
            make.leading.equalToSuperview().inset(20)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        categoryArticleCollectionLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(20)
        }
        categoryArticleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryArticleCollectionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
    
    func setNavigation() {
        NavigationBarLayoutManager.add(navigationBar)
    }
}

extension ArticleCategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyCase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ArticleCategoryCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
        cell.inputData = dummyCase[indexPath.item]
        return cell
    }
    
}

extension ArticleCategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (Constant.Screen.width - Size.cellOffset) / Size.edgesOffset
        let height = width * (112/162)
        return CGSize(width: width, height: height)
    }
}
