//
//  BookMarkViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 BookMark. All rights reserved.
//

import UIKit

import SnapKit

protocol BookmarkManger {
    func getBookmark() async throws -> BookmarkAppData
    func postBookmark(model: BookmarkRequest) async throws
}

final class BookmarkViewController: UIViewController {
    
    private let manager: BookmarkManger
    
    private lazy var navigationBar = LHNavigationBarView(type: .bookmark, viewController: self)
    private lazy var bookmarkCollectionView = LHCollectionView()
    
    private var bookmarkAppData = BookmarkAppData(nickName: "", articleSummaries: [ArticleSummaries]())
    private var bookmarkList = [ArticleSummaries]()
    
    init(manager: BookmarkManger) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        showLoading()
        
        Task {
            do {
                self.bookmarkAppData = try await manager.getBookmark()
                self.bookmarkList = bookmarkAppData.articleSummaries
                hideLoading()
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
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, bookmarkCollectionView)
    }
    
    func setLayout() {

        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
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
            let splashViewController = SplashViewController(manager: SplashManagerImpl(authService: AuthServiceImpl(apiService: APIService())))
            ViewControllerUtil.setRootViewController(window: window, viewController: splashViewController, withAnimation: false)
        case .clientError(_, let message):
            LHToast.show(message: message)
        case .serverError:
            LHToast.show(message: "server error")
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
            cell.inputData = bookmarkAppData
            return cell
        } else {
            let cell = BookmarkListCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.inputData = bookmarkList[indexPath.item]
            
            cell.bookmarkButtonClosure = { indexPath in
                Task {
                    do {
                        try await self.manager.postBookmark(model: BookmarkRequest(articleId: self.bookmarkList[indexPath.item].articleID,
                                                                                            bookmarkRequestStatus: !self.bookmarkList[indexPath.item].bookmarked))
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

extension BookmarkViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presentArticleDetailFullScreen(articleID: bookmarkList[indexPath.item].articleID)
    }
}
