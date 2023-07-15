//
//  MyPageViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 MyPage. All rights reserved.
//

import UIKit

import SnapKit

final class MyPageViewController: UIViewController {
    
    private let myPageServiceLabelList = MyPageLocalData.myPageServiceLabelList
    private let myPageSectionLabelList = MyPageLocalData.myPageSectionLabelList
    private let myPageAppSettingLabelList = MyPageAppSettinLocalgData.myPageAppSettingDataList
    
    private lazy var navigtaionBar = LHNavigationBarView(type: .myPage, viewController: self)

    private let myPageCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
        setDelegate()
        registerCell()
        hiddenNavigationBar()

    }
}

private extension MyPageViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(navigtaionBar, myPageCollectionView)
    }
    
    func setLayout() {
        navigtaionBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        myPageCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigtaionBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        myPageCollectionView.delegate = self
        myPageCollectionView.dataSource = self
    }
    
    func registerCell() {
        MyPageProfileCollectionViewCell.register(to: myPageCollectionView)
        MyPageCustomerServiceCollectionViewCell.register(to: myPageCollectionView)
        MyPageAppSettingCollectionViewCell.register(to: myPageCollectionView)
        MyPageHeaderView.registerHeaderView(to: myPageCollectionView)
    }
    
    func hiddenNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension MyPageViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return myPageServiceLabelList.count
        } else {
            return myPageAppSettingLabelList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = MyPageProfileCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            return cell
        } else if indexPath.section == 1 {
            let cell = MyPageCustomerServiceCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.inputData = myPageServiceLabelList[indexPath.item]
            return cell
        } else {
            let cell = MyPageAppSettingCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.inputData = myPageAppSettingLabelList[indexPath.item]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            return UICollectionReusableView()
        }
        let headerView = MyPageHeaderView.dequeueReusableheaderView(to: collectionView, viewForSupplementaryElementOfKind: kind, indexPath: indexPath)
        headerView.inputData = myPageSectionLabelList[indexPath.section-1]
        return headerView
    }
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(224/360))
        } else if indexPath.section == 1 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(52/360))
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(62/360))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        section == 2 ? UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0) : UIEdgeInsets(top: 0, left: 0, bottom: 36, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        section == 0 ? CGSize() : CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(36/360))
    }
}
