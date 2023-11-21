//
//  ArticleListByCategoryViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 ArticleListByCategory. All rights reserved.
//

import UIKit

import SnapKit

final class ArticleListByCategoryViewController: UIViewController, ArticleListByCategoryViewControllerable {
    
    var navigator: ArticleListByCategoryNavigation
    private let manager: ArticleListByCategoryManager
    
    private lazy var navigationBar = LHNavigationBarView(type: .exploreEachCategory, viewController: self)
    private let articleListTableView = ArticleListTableView()
    
    var categoryString: String?
    var articleListData: [ArticleDataByWeek] = [] {
        didSet {
            articleListTableView.reloadData()
        }
    }
    
    init(manager: ArticleListByCategoryManager, navigator: ArticleListByCategoryNavigation) {
        self.manager = manager
        self.navigator = navigator
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
        setAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        Task {
            do {
                guard let categoryString else { return }
                self.articleListData = try await manager.getArticleListByCategory(categoryString: categoryString).articleData
                self.articleListTableView.reloadData()
                hideLoading()
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
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
        articleListTableView.dataSource = self
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
        self.navigator.articleListByCategoryCellTapped(articleID: articleListData[indexPath.row].articleId)
    }
}
