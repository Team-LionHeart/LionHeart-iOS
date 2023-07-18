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
    
    private var bookmarkDataList: [String] = ["1", "2", "3", "4", "5", "", ""]
    
    private lazy var navigationBar = LHNavigationBarView(type: .bookmark, viewController: self)
    
    private lazy var bookmarkCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .designSystem(.background)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        registerCell()
        setTabbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

private extension BookmarkViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, bookmarkCollectionView)
    }
    
    func setLayout() {
        NavigationBarLayoutManager.add(navigationBar)
        bookmarkCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setDelegate() {
        bookmarkCollectionView.delegate = self
        bookmarkCollectionView.dataSource = self
    }
    func registerCell() {
        BookmarkDetailCollectionViewCell.register(to: bookmarkCollectionView)
        BookmarkListCollectionViewCell.register(to: bookmarkCollectionView)
    }
    
    func setTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension BookmarkViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            bookmarkDataList.isEmpty ?
            collectionView.setEmptyView(emptyText: """
                                                   아직 담아본 아티클이 없어요.
                                                   다른 아티클을 읽어볼까요?
                                                   """) :
            collectionView.restore()
            return bookmarkDataList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = BookmarkDetailCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            return cell
        } else {
            let cell = BookmarkListCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.bookmarkButtonClosure = { indexPathItem in
                self.bookmarkDataList.remove(at: indexPathItem)
                collectionView.deleteItems(at: [IndexPath(item: indexPathItem, section: 1)])
                LHToast.show(message: "북마크가 해제되었습니다")
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: Constant.Screen.width, height: ScreenUtils.getHeight(124))
        } else {
            return CGSize(width: Constant.Screen.width - 40, height: ScreenUtils.getHeight(100))
        }
    }
}

extension BookmarkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        section == 1 ? UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) : UIEdgeInsets()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        section == 1 ? 20 : CGFloat()
    }
}
