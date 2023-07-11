//
//  BookMarkViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 BookMark. All rights reserved.
//

import UIKit

import SnapKit

final class BookmarkViewController: UIViewController {
    
    private lazy var navigationBar = LHNavigationBarView(type: .bookmark, viewController: self)
    
    private let bookmarkDetailLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     사랑이 아빠님이
                     보관한 아티클이에요
                     """
        label.numberOfLines = 0
        label.font = .pretendard(.head3)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    private lazy var bookmarkCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
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
        
        registerCell()

    }
}

private extension BookmarkViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, bookmarkDetailLabel, bookmarkCollectionView)
    }
    
    func setLayout() {
        NavigationBarLayoutManager.add(navigationBar)
        
        bookmarkDetailLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(20)
        }
        
        bookmarkCollectionView.snp.makeConstraints {
            $0.top.equalTo(bookmarkDetailLabel.snp.bottom).offset(36)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        bookmarkCollectionView.delegate = self
        bookmarkCollectionView.dataSource = self
    }
    
    func registerCell() {
        BookmarkCollectionViewCell.register(to: bookmarkCollectionView)
    }
    
    func setArticleCollectionViewlayout() {
        
    }
}

extension BookmarkViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = BookmarkCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Constant.Screen.width - 40
        let height = width * (100/320)
        return CGSize(width: width, height: height)
    }
}

extension BookmarkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
