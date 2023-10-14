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
    
    weak var coordinator: CurriculumListByWeekNavigation?
    
    private let manager: CurriculumListManager
    
    private let curriculumListByWeekCollectionView = LHCollectionView(color: .background, scroll: false)
    private lazy var navigationBar = LHNavigationBarView(type: .curriculumByWeek, viewController: self)
    
    var weekToIndexPathItem: Int = 0
    var listByWeekDatas: CurriculumWeekData? {
        didSet {
            self.curriculumListByWeekCollectionView.reloadData()
        }
    }
    
    var currentPage: Int = -1 {
        didSet {
            setCurriculumList(oldValue: oldValue, by: currentPage)
        }
    }
    
    init(manager: CurriculumListManager) {
        self.manager = manager
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
        setDelegate()
        setCollectionView()
        setNotificationCenter()
        setAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        getListByWeekData()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(item: self.weekToIndexPathItem, section: 0)
        self.curriculumListByWeekCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    deinit {
        removeNotificationCenter()
    }
}

private extension CurriculumListByWeekViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, curriculumListByWeekCollectionView)
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        navigationBar.setCurriculumWeek(week: self.weekToIndexPathItem + 4)
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
        self.navigationBar.backButtonAction {
            self.coordinator?.backButtonTapped()
        }
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(bookmarkButtonTapped), name: NSNotification.Name("isArticleBookmarked"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectTableVIewCell), name: NSNotification.Name("didSelectTableViewCell"), object: nil)
        
    }

    func removeNotificationCenter() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func bookmarkButtonTapped(notification: NSNotification) {
        Task {
            do {
                guard let indexPath = notification.userInfo?["bookmarkCellIndexPath"] as? Int else { return }
                guard let buttonSelected = notification.userInfo?["bookmarkButtonSelected"] as? Bool else { return }
                guard let listByWeekDatas else { return }
                self.listByWeekDatas?.articleData[indexPath].isArticleBookmarked.toggle()
                try await manager.postBookmark(model: BookmarkRequest(articleId: listByWeekDatas.articleData[indexPath].articleId,
                                                                    bookmarkRequestStatus: buttonSelected))
                hideLoading()
                buttonSelected ? LHToast.show(message: "북마크가 추가되었습니다", isTabBar: true) : LHToast.show(message: "북마크가 해제되었습니다", isTabBar: true)
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
    
    @objc func leftButtonTapped(notification: NSNotification) {
        let nextIndexPathItem = self.currentPage == -1 ? weekToIndexPathItem - 1 : currentPage - 1
        let nextPage: Int = max(0, nextIndexPathItem)
        self.currentPage = nextPage
    }
    
    @objc func rightButtonTapped(notification: NSNotification) {
        let nextIndexPathItem = self.currentPage == -1 ? weekToIndexPathItem + 1 : currentPage + 1
        let nextPage = min(36, nextIndexPathItem)
        self.currentPage = nextPage
    }
    
    @objc func didSelectTableVIewCell(notification: NSNotification) {
        guard let articleId = notification.object as? Int else { return }
        self.coordinator?.curriculumArticleListCellTapped(articleId: articleId)
    }
    
    func setDelegate() {
        curriculumListByWeekCollectionView.delegate = self
        curriculumListByWeekCollectionView.dataSource = self
    }
    
    func setCollectionView() {
        CurriculumListByWeekCollectionViewCell.register(to: curriculumListByWeekCollectionView)
    }
}

extension CurriculumListByWeekViewController {
    func setCurriculumList(oldValue: Int, by indexPath: Int) {
        let indexPath = IndexPath(item: currentPage, section: 0)
        self.curriculumListByWeekCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let week = currentPage + 4
        self.navigationBar.setCurriculumWeek(week: week)
        if oldValue == currentPage { return }
        Task {
            showLoading()
            let articlesByWeek = try await manager.getArticleListByWeekInfo(week: week)
            self.listByWeekDatas = articlesByWeek
            hideLoading()
        }
    }
}

extension CurriculumListByWeekViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 37
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CurriculumListByWeekCollectionViewCell.dequeueReusableCell(to: curriculumListByWeekCollectionView, indexPath: indexPath)
        cell.weekCount = listByWeekDatas?.week
        cell.inputData = listByWeekDatas
        cell.selectedIndexPath = indexPath
        return cell
    }
}

extension CurriculumListByWeekViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension CurriculumListByWeekViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .unAuthorizedError:
            self.coordinator?.checkTokenIsExpired()
        case .clientError(code: _, message: let message):
            LHToast.show(message: "\(message)")
        default:
            LHToast.show(message: error.description)
        }
    }
}

extension CurriculumListByWeekViewController {
    func getListByWeekData() {
        Task {
            do {
                let responseListByWeek = try await manager.getArticleListByWeekInfo(week: weekToIndexPathItem + 4)
                listByWeekDatas = responseListByWeek
                hideLoading()
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}
