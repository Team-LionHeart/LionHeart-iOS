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

    private lazy var navigationBar = LHNavigationBarView(type: .explore, viewController: self)
    private lazy var titleLabel = LHLabel(type: .head2, color: .white, lines: 2, basicText: "카테고리별\n아티클 모아보기")
    private lazy var subtitleLabel = LHLabel(type: .body3R, color: .gray400, basicText: "똑똑한 아빠들의 비밀 습관")
    private lazy var categoryArticleCollectionView = LHCollectionView(color: .background)
    
    private var dummyCase = CategoryImage.dummy()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setNavigation()
        setLayout()
        setAddTarget()
        setDelegate()
        setCollectionView()
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
    
    func setAddTarget() {
        navigationBar.rightFirstBarItemAction {
            let bookmarkViewController = BookmarkViewController(manager: BookmarkMangerImpl(bookmarkService: BookmarkServiceImpl(apiService: APIService())))
            self.navigationController?.pushViewController(bookmarkViewController, animated: true)
        }
        
        navigationBar.rightSecondBarItemAction {
            let mypageViewController = MyPageViewController(manager: MyPageManagerImpl(mypageService: MyPageServiceImpl(apiService: APIService()), authService: AuthServiceImpl(apiService: APIService())))
            self.navigationController?.pushViewController(mypageViewController, animated: true)
        }
    }
    
    func setDelegate() {
        categoryArticleCollectionView.delegate = self
        categoryArticleCollectionView.dataSource = self
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

extension ArticleCategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyCase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ArticleCategoryCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
        cell.inputData = dummyCase[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articleListbyCategoryViewController = ArticleListByCategoryViewController(manager: ArticleListByCategoryMangerImpl(articleService: ArticleServiceImpl(apiService: APIService()), bookmarkService: BookmarkServiceImpl(apiService: APIService())))
        articleListbyCategoryViewController.categoryString = dummyCase[indexPath.item].categoryString
        self.navigationController?.pushViewController(articleListbyCategoryViewController, animated: true)
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
