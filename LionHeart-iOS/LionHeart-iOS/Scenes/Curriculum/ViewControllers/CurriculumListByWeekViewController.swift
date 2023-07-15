//
//  CurriculumListByWeekViewController.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/14.
//  Copyright (c) 2023 CurriculumListByWeek. All rights reserved.
//

import UIKit

import SnapKit

final class CurriculumListByWeekViewController: UIViewController {
    
    var listByWeekDatas = CurriculumWeekData.dummy() {
        didSet{
            self.curriculumListByWeekCollectionView.reloadData()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            let indexPath = IndexPath(item: currentPage, section: 0)
            self.curriculumListByWeekCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            self.navigationBar.setCurriculumWeek(week: currentPage+1)
        }
    }
    
    private lazy var navigationBar = LHNavigationBarView(type: .curriculumByWeek, viewController: self)
    
    private let curriculumListByWeekCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .designSystem(.background)
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
        
        // MARK: - collectionView Register 설정
        setCollectionView()
        
        // MARK: - notificationCenter 설정
        setNotificationCenter()
        
    }
}

private extension CurriculumListByWeekViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        self.navigationController?.isNavigationBarHidden = true
        view.addSubviews(navigationBar, curriculumListByWeekCollectionView)
        navigationBar.setCurriculumWeek(week: 1)
        
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        curriculumListByWeekCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(leftButtonTapped),
                                               name: NSNotification.Name("leftButton"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(rightButtonTapped),
                                               name: NSNotification.Name("rightButton"),
                                               object: nil)
    }
    
    @objc
    func leftButtonTapped(notification: NSNotification) {
        let nextPage: Int = max(0,currentPage - 1)
        self.currentPage = nextPage
        
    }
    
    @objc
    func rightButtonTapped(notification: NSNotification) {
        let nextPage = min(3,currentPage + 1)
        self.currentPage = nextPage
        
    }
    
    func setDelegate() {
        
        curriculumListByWeekCollectionView.delegate = self
        curriculumListByWeekCollectionView.dataSource = self
        
    }
    
    func setCollectionView() {
        CurriculumListByWeekCollectionViewCell.register(to: curriculumListByWeekCollectionView)
    }
}

extension CurriculumListByWeekViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listByWeekDatas.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CurriculumListByWeekCollectionViewCell.dequeueReusableCell(to: curriculumListByWeekCollectionView, indexPath: indexPath)
        cell.inputData = listByWeekDatas[indexPath.item]
        cell.selectedIndexPathData = indexPath
        
        return cell
    }
}

extension CurriculumListByWeekViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
