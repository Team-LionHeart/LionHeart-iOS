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
    
    private var bookmarkAppData = BookmarkAppData(nickName: "", articleSummaries: [ArticleSummaries]())
    private var bookmarkList = [ArticleSummaries]()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicator.showLoading()
        Task {
            do {
                self.bookmarkAppData = try await BookmarkService.shared.getBookmark()
                self.bookmarkList = bookmarkAppData.articleSummaries
                LoadingIndicator.hideLoading()
                bookmarkCollectionView.reloadData()
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
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

extension BookmarkViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .urlEncodingError:
            LHToast.show(message: "URL Error")
        case .jsonDecodingError:
            LHToast.show(message: "Decoding Error")
        case .badCasting:
            LHToast.show(message: "Bad Casting")
        case .fetchImageError:
            LHToast.show(message: "Image Error")
        case .unAuthorizedError:
            guard let window = self.view.window else { return }
            ViewControllerUtil.setRootViewController(window: window, viewController: SplashViewController(), withAnimation: false)
        case .clientError(_, _):
            print("뜨면 위험함")
        case .serverError:
            LHToast.show(message: "승준이 빠따")
        }
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
            self.bookmarkList.isEmpty ?
            collectionView.setEmptyView(emptyText: """
                                                   아직 담아본 아티클이 없어요.
                                                   다른 아티클을 읽어볼까요?
                                                   """) :
            collectionView.restore()
            return self.bookmarkList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = BookmarkDetailCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            return cell
        } else {
            let cell = BookmarkListCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            
            cell.bookmarkButtonClosure = { indexPath in
                Task {
                    do {
                        try await BookmarkService.shared.postBookmark(BookmarkRequest(articleId: self.bookmarkList[indexPath.item].articleID,
                                                                                      bookmarkStatus: !self.bookmarkList[indexPath.item].bookmarked))
                        self.bookmarkList.remove(at: indexPath.item)
                        collectionView.deleteItems(at: [indexPath])
                        LHToast.show(message: "북마크가 해제되었습니다")
                    } catch {
                        guard let error = error as? NetworkError else { return }
                        self.handleError(error)
                    }
                }
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
