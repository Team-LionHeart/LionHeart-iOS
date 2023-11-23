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
        setLayout()
        setTabbar()
        setDelegate()
        setDataSource()
        bind()
        bindInput()
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
    
    func setDelegate() {
        bookmarkCollectionView.delegate = self
    }
    
    private func bind() {
        let input = BookmarkViewModelInput(viewWillAppear: viewWillAppear,
                                           articleCellTapped: articleCellTapped,
                                           bookmarkButtonTapped: bookmarkButtonTapped,
                                           backButtonTapped: backButtonTapped)
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppear
            .sink { [weak self] data in
                self?.updateDiffableDataSource(sectionModel: data)
            }
            .store(in: &cancelBag)
        
        output.bookmarkButtonTapped
            .sink { [weak self] data in
                self?.updateDiffableDataSource(sectionModel: data)
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
    
    private func updateDiffableDataSource(sectionModel: BookmarkAppData) {
        var snapshot = NSDiffableDataSourceSnapshot<BookmarkSection, BookmarkRow>()
        snapshot.appendSections([.detailBookmark, .listBookmark])
        snapshot.appendItems([BookmarkRow.detail(nickname: sectionModel.nickName)], toSection: .detailBookmark)

        var item = sectionModel.articleSummaries.map {
            return BookmarkRow.list(articleList: ArticleSummaries(title: $0.title, articleID: $0.articleID, articleImage: $0.articleImage, bookmarked: $0.bookmarked, tags: $0.tags))
        }
        
        if item.isEmpty {
            item = [BookmarkRow.list(articleList: ArticleSummaries.empty)]
        }
    
        snapshot.appendItems(item, toSection: .listBookmark)
        self.diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setDataSource() {
        self.diffableDataSource = UICollectionViewDiffableDataSource<BookmarkSection, BookmarkRow>(collectionView: self.bookmarkCollectionView, cellProvider: {
            collectionView, indexPath, identifier in
            
            switch identifier {
                
            case .detail(let nickname):
                let cell = BookmarkDetailCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
                cell.inputData = nickname
                return cell
            case .list(let bookmarkAppData):
                let cell = BookmarkListCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
                
                if bookmarkAppData.title == "empty" {
                    collectionView.setEmptyView(emptyText: """
                                                            아직 담아본 아티클이 없어요.
                                                            다른 아티클을 읽어볼까요?
                                                            """)
                    cell.isHidden = true
                } else {
                    cell.inputData = bookmarkAppData
                    
                    cell.bookmarkButtonTapped
                        .sink { [weak self] indexPath in
                            self?.bookmarkButtonTapped.send(indexPath)
                        }
                        .store(in: &self.cancelBag)
                }
                return cell
            }
        })
    }
}

extension BookmarkViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.articleCellTapped.send(indexPath)
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
}
