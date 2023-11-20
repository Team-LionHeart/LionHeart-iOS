//
//  BookMarkViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 BookMark. All rights reserved.
//

import UIKit
import Combine

import SnapKit

protocol BookmarkViewControllerable where Self: UIViewController { }

final class BookmarkViewController: UIViewController, BookmarkViewControllerable {
    
    enum BookmarkSection: Int {
        case detailBookmark
        case listBookmark
    }
    
    private let viewWillAppear = PassthroughSubject<Void, Never>()
    private let articleCellTapped = PassthroughSubject<IndexPath, Never>()
    private let bookmarkButtonTapped = PassthroughSubject<IndexPath, Never>()
    private let backButtonTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private let viewModel: any BookmarkViewModel
    private lazy var navigationBar = LHNavigationBarView(type: .bookmark, viewController: self)
    private lazy var bookmarkCollectionView = LHCollectionView()
    private var diffableDataSource: UICollectionViewDiffableDataSource<BookmarkSection, BookmarkRow>!
    
    private var bookmarkAppData: BookmarkAppData?
    
    init(viewModel: some BookmarkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        registerCell()
        setTabbar()
        setDataSource()
        
        bind()
        bindInput()
        setDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        
        viewWillAppear.send(())
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

    func registerCell() {
        BookmarkDetailCollectionViewCell.register(to: bookmarkCollectionView)
        BookmarkListCollectionViewCell.register(to: bookmarkCollectionView)
    }
    
    func setTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func bind() {
        let input = BookmarkViewModelInput(viewWillAppear: viewWillAppear,
                                           articleCellTapped: articleCellTapped,
                                           bookmarkButtonTapped: bookmarkButtonTapped,
                                           backButtonTapped: backButtonTapped)
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppear
            .sink { [weak self] result in
                switch result {
                case .success(let data):
                    // 데이터!
                    self?.updateDiffableDataSource(section: data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .store(in: &cancelBag)
    }
    
    private func bindInput() {
        navigationBar.leftBarItem.tapPublisher
            .sink { [weak self] in
                self?.backButtonTapped.send(())
            }
            .store(in: &cancelBag)
    }
    
    private func updateDiffableDataSource(section: BookmarkSectionModel) {
        var snapshot = NSDiffableDataSourceSnapshot<BookmarkSection, BookmarkRow>()
        snapshot.appendSections([.detailBookmark, .listBookmark])
        snapshot.appendItems(section.detailData, toSection: .detailBookmark)
        print("출력점", section.listData)
        snapshot.appendItems(section.listData, toSection: .listBookmark)
        self.diffableDataSource.apply(snapshot)
    }
    
    private func setDataSource() {
        self.diffableDataSource = UICollectionViewDiffableDataSource<BookmarkSection, BookmarkRow>(collectionView: self.bookmarkCollectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            
            switch identifier {
                
            case .detail(let nickname):
                let cell = BookmarkDetailCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
                cell.inputData = nickname
                return cell
            case .list(let appData):
                let cell = BookmarkListCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
                
                if appData.isEmpty {
                    collectionView.setEmptyView(emptyText: """
                                                            아직 담아본 아티클이 없어요.
                                                            다른 아티클을 읽어볼까요?
                                                            """)
                    return cell
                    
                } else {
                    // indexPath 안 써도 되는 거 아니뉴
                    cell.inputData = appData[indexPath.item]
                    cell.bookmarkButtonClosure = { indexPath in
                        self.bookmarkButtonTapped.send(indexPath)
                    }
                    return cell
                }
                
                // 북마크 데이터 상태값 전환 후, collectionViewData 지우기
                
                // 이거 이따가...
                //                        collectionView.deleteItems(at: [indexPath])
                //                        LHToast.show(message: "북마크가 해제되었습니다")
            }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: Constant.Screen.width, height: ScreenUtils.getHeight(124))
        } else {
            return CGSize(width: Constant.Screen.width - 40, height: ScreenUtils.getHeight(100))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.articleCellTapped.send(indexPath)
    }
}
