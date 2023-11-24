//
//  ArticleListByCategoryViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 ArticleListByCategory. All rights reserved.
//

import UIKit
import Combine

import SnapKit

protocol ArticleListByCategoryViewControllerable where Self: UIViewController {}

final class ArticleListByCategoryViewController: UIViewController, ArticleListByCategoryViewControllerable {
    
    private let viewWillAppear = PassthroughSubject<Void, Never>()
    private let backButtonTapped = PassthroughSubject<Void, Never>()
    private let bookmarkTapped = PassthroughSubject<(isSelected: Bool, indexPath: IndexPath), Never>()
    private let articleCellTapped = PassthroughSubject<IndexPath, Never>()
    
    private lazy var navigationBar = LHNavigationBarView(type: .exploreEachCategory, viewController: self)
    
    private let articleListTableView = ArticleListTableView()
    
    private let viewModel: any ArticleListByCategoryViewModel
    
    private var datasource: UITableViewDiffableDataSource<ArticleListByCategorySection, ArticleListByCategoryItem>!
    
    private var cancelBag = Set<AnyCancellable>()
    
    init(viewModel: some ArticleListByCategoryViewModel) {
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
        setLayout()
        setDelegate()
        setTableView()
        bindInput()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        viewWillAppear.send(())
    }
    
    func bindInput() {
        navigationBar.leftBarItem
            .tapPublisher
            .sink { _ in
                self.backButtonTapped.send(())
            }
            .store(in: &cancelBag)
    }
    
    func bind() {
        let input = ArticleListByCategoryViewModelInput(viewWillAppear: viewWillAppear,
                                                        backButtonTapped: backButtonTapped,
                                                        bookmarkTapped: bookmarkTapped,
                                                        articleCellTapped: articleCellTapped)
        let output = viewModel.transform(input: input)
        // 북마크 토스트 메시지 띄우기
        output.bookmarkCompleted
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                print(message)
            }
            .store(in: &cancelBag)
        
        output.articles
            .receive(on: RunLoop.main)
            .sink { [weak self] articleDatas in
                guard let self else { return }
                self.setDataSource()
                self.applySnapshot(articleDatas: articleDatas)
                self.hideLoading()
            }
            .store(in: &cancelBag)
    }
}

extension ArticleListByCategoryViewController {
    func setDataSource() {
        self.datasource = UITableViewDiffableDataSource(tableView: self.articleListTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .article(let articleData):
                let cell = CurriculumArticleByWeekTableViewCell.dequeueReusableCell(to: self.articleListTableView)
                cell.inputData = articleData
                cell.selectionStyle = .none
                
                cell.bookmarkSubject
                    .sink { isSelected in
                        self.bookmarkTapped.send((isSelected: isSelected, indexPath: indexPath))
                    }
                    .store(in: &cell.cancelBag)
                
                return cell
            }
        })
    }
    
    func applySnapshot(articleDatas: [ArticleDataByWeek]) {
        var snapshot = NSDiffableDataSourceSnapshot<ArticleListByCategorySection, ArticleListByCategoryItem>()
        snapshot.appendSections([.article])
        
        let items = articleDatas.map {
            return ArticleListByCategoryItem.article(data: $0)
        }
        
        snapshot.appendItems(items, toSection: .article)
        self.datasource.apply(snapshot)
    }
}

private extension ArticleListByCategoryViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, articleListTableView)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        articleListTableView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setDelegate() {
        articleListTableView.delegate = self
    }
    
    func setTableView() {
        CurriculumArticleByWeekTableViewCell.register(to: articleListTableView)
    }
}

extension ArticleListByCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.articleCellTapped.send(indexPath)
    }
}
