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
        static let numberOfCellsinRow: CGFloat = 2
        static let imageWidth: CGFloat = 162
        static let imageHeight: CGFloat = 112
    }
    
    private lazy var navigationBar = LHNavigationBarView(type: .explore, viewController: self)
    
    private var dummyCase = CategoryImage.dummy() {
        didSet {
            self.categoryArticleCollectionView.reloadData()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리별\n아티클 모아보기"
        label.numberOfLines = 2
        label.font = .pretendard(.head2)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "똑똑한 아빠들의 비밀 습관"
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray400)
        return label
    }()
   
    private lazy var categoryArticleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .designSystem(.background)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        setHierarchy()
        setNavigation()
        
        // MARK: - autolayout설정
        setLayout()
        
        // MARK: - button의 addtarget설정
        setAddTarget()
        
        // MARK: - delegate설정
        setDelegate()
    
    }
}

private extension ArticleCategoryViewController {
    func setUI() {
        ArticleCategoryCollectionViewCell.register(to: categoryArticleCollectionView)
        self.navigationController?.isNavigationBarHidden = true
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
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        categoryArticleCollectionView.delegate = self
        categoryArticleCollectionView.dataSource = self
    }
    
    func setNavigation() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
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
