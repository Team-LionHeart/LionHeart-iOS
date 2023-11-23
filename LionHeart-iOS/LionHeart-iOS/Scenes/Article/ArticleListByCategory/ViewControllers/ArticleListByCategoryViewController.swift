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
        output.bookmarkCompleted
            .sink { message in
                print(message)
            }
            .store(in: &cancelBag)
        
        output.articles
            .sink { [weak self] articleDatas in
                guard let self else { return }
                self.setDataSource()
                self.applySnapshot(articleDatas: articleDatas)
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
                
                cell.bookMarkButton.tapPublisher
                    .sink { [weak self] _ in
                        self?.bookmarkTapped.send((isSelected: cell.isSelected, indexPath: indexPath))
                    }
                    .store(in: &self.cancelBag)
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
  
    func setAddTarget() {
        navigationBar.backButtonAction {
            self.navigator.backButtonTapped()
        }
    }
}

//extension ArticleListByCategoryViewController: ViewControllerServiceable {
//    func handleError(_ error: NetworkError) {
//        switch error {
//        case .urlEncodingError:
//            LHToast.show(message: "URL Error")
//        case .jsonDecodingError:
//            LHToast.show(message: "Decoding Error")
//        case .badCasting:
//            LHToast.show(message: "Bad Casting")
//        case .fetchImageError:
//            LHToast.show(message: "Image Error")
//        case .unAuthorizedError:
//            navigator.checkTokenIsExpired()
//        case .clientError(_, let message):
//            LHToast.show(message: message)
//        case .serverError:
//            LHToast.show(message: error.description)
//        }
//    }
//}

extension ArticleListByCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CurriculumArticleByWeekTableViewCell.dequeueReusableCell(to: articleListTableView)
        cell.inputData = articleListData[indexPath.row]
        cell.selectionStyle = .none
//        cell.bookMarkButtonTapped = { isSelected, indexPath in
//            Task {
//                do {
//                    try await self.manager.postBookmark(model: BookmarkRequest(articleId: self.articleListData[indexPath.row].articleId,
//                                                                                  bookmarkRequestStatus: isSelected))
//                    isSelected ? LHToast.show(message: "북마크에 추가되었습니다", isTabBar: true) : LHToast.show(message: "북마크에 해제되었습니다", isTabBar: true)
//                } catch {
//                    guard let error = error as? NetworkError else { return }
//                    self.handleError(error)
//                }
//            }
//        }
        return cell
    }
}

extension ArticleListByCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.articleCellTapped.send(indexPath)
    }
}
