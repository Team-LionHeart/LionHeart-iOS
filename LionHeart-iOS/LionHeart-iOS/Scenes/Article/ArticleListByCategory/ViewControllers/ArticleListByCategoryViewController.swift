//
//  ArticleListByCategoryViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 ArticleListByCategory. All rights reserved.
//

import UIKit

import SnapKit

final class ArticleListByCategoryViewController: UIViewController {
    
    var categoryString = String()
    var articleListData: [ArticleDataByWeek] = [] {
        didSet {
            articleListTableView.reloadData()
        }
    }
    
    private lazy var navigationBar = LHNavigationBarView(type: .exploreEachCategory, viewController: self)
    
    private let articleListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .designSystem(.background)
        let view = ArticleListByCategoryHeaderView()
        view.frame = CGRect(x: 0, y: 0, width: Constant.Screen.width, height: ScreenUtils.getHeight(136))
        tableView.separatorStyle = .none
        tableView.tableHeaderView = view
        tableView.estimatedRowHeight = 326
        let footerView = UIView()
        footerView.frame = .init(x: 0, y: 0, width: Constant.Screen.width, height: 100)
        tableView.tableFooterView = footerView
        return tableView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setTableView()
        setNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        Task {
            do {
                self.articleListData = try await ArticleService.shared.getArticleListByCategory(categoryString: categoryString).articleData
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
    
    func setNotificationCenter() {
//        NotificationCenter.default.addObserver(self, selector: #selector(bookmarkButtonTapped), name: NSNotification.Name("isArticleBookmarked"), object: nil)
    }
    
//    @objc func bookmarkButtonTapped(notification: NSNotification) {
//        Task {
//            do {
//                guard let indexPath = notification.userInfo?["bookmarkCellIndexPath"] as? Int else { return }
//                guard let buttonSelected = notification.userInfo?["bookmarkButtonSelected"] as? Bool else { return }
//
//                try await BookmarkService.shared.postBookmark(BookmarkRequest(articleId: articleListData[indexPath+1].articleId,
//                                                                              bookmarkStatus: buttonSelected))
//                buttonSelected ? LHToast.show(message: "북마크에 추가되었습니다", isTabBar: true) : LHToast.show(message: "북마크에 해제되었습니다", isTabBar: true)
//            } catch {
//                guard let error = error as? NetworkError else { return }
//                handleError(error)
//            }
//        }
//    }
}

extension ArticleListByCategoryViewController: ViewControllerServiceable {
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

extension ArticleListByCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CurriculumArticleByWeekTableViewCell.dequeueReusableCell(to: articleListTableView)
        cell.inputData = articleListData[indexPath.row]

        cell.bookMarkButtonTapped = { isSelected, indexPath in


            Task {
                do {
                    try await BookmarkService.shared.postBookmark(BookmarkRequest(articleId: self.articleListData[indexPath.row].articleId,
                                                                                  bookmarkRequestStatus: isSelected))
                    print(self.articleListData[indexPath.row].articleId)
                    isSelected ? LHToast.show(message: "북마크에 추가되었습니다", isTabBar: true) : LHToast.show(message: "북마크에 해제되었습니다", isTabBar: true)
                } catch {
                    guard let error = error as? NetworkError else { return }
                    self.handleError(error)
                }
            }

        }

        return cell
    }
}

extension ArticleListByCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentArticleDetailFullScreen(articleID: articleListData[indexPath.row].articleId)
    }
}
