//
//  ArticleDetailViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 ArticleDetail. All rights reserved.
//

import UIKit

import SnapKit

final class ArticleDetailViewController: UIViewController {

    // MARK: - UI Components
    private lazy var navigationBar = LHNavigationBarView(type: .articleMain, viewController: self)
    
    private var progressBar = LHProgressView()

    private let articleTableView = ArticleDetailTableView()
    
    private let loadingIndicatorView = LHLoadingView()

    private lazy var scrollToTopButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Article.icFab, for: .normal)
        button.addButtonAction { _ in
            let indexPath = IndexPath(row: 0, section: 0)
            self.articleTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            button.isHidden = true
        }
        button.isHidden = true
        return button
    }()

    // MARK: - Properties

    private var articleDatas: [BlockTypeAppData]? {
        didSet {
            self.articleTableView.reloadData()
            hideLoading()
        }
    }

//    private var articleDatas: [BlockTypeAppData] = ArticleDetail.dummy().toAppData()

    private var isArticleMarked: Bool?

    private var articleId: Int?

    private var contentOffsetY: CGFloat = 0

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setTableView()
        setNavigationBar()
        setTabbar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        getArticleDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Network

extension ArticleDetailViewController {
    private func getArticleDetail() {
        Task {
            do {
                guard let articleId else { return }
                self.articleDatas = try await ArticleService.shared.getArticleDetail(articleId: articleId)
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }

    private func articleBookMark(articleId: Int, isSelected: Bool) {
        Task {
            do {
                let bookmarkRequest = BookmarkRequest(articleId: articleId, bookmarkStatus: isSelected)
                try await BookmarkService.shared.postBookmark(bookmarkRequest)
            } catch {
                guard let error = error as? NetworkError else { return }
                self.handleError(error)
            }
        }

    }
}

extension ArticleDetailViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .unAuthorizedError:
            guard let window = self.view.window else { return }
            ViewControllerUtil.setRootViewController(window: window, viewController: SplashViewController(), withAnimation: false)
        case .clientError(_, let message):
            LHToast.show(message: "\(message)")
        default:
            LHToast.show(message: error.description)
        }
    }
}

// MARK: - UI & Layout

private extension ArticleDetailViewController {
    
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, articleTableView, progressBar, scrollToTopButton)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }

        articleTableView.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        scrollToTopButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(36)
        }
    }

    func setTableView() {
        articleTableView.delegate = self
        articleTableView.dataSource = self
    }

    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension ArticleDetailViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.height)
        progressBar.setProgress(Float(progress), animated: true)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // 컨텐츠를 위로 올릴 시
        if velocity.y <= 0 {
            self.scrollToTopButton.isHidden = false
        } else {
            // 컨텐츠를 아래로 내릴 시
            self.scrollToTopButton.isHidden = true
        }
    }

}

extension ArticleDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleDatas?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let articleDatas else { return UITableViewCell() }
        switch articleDatas[indexPath.row] {
        case .thumbnail(let isMarked, let thumbnailModel):
            let cell = ThumnailTableViewCell.dequeueReusableCell(to: articleTableView)
            self.isArticleMarked = isMarked
            cell.isMarked = self.isArticleMarked
            cell.inputData = thumbnailModel
            
            cell.selectionStyle = .none
            cell.bookmarkButtonDidTap = { isSelected in
                guard let articleId = self.articleId else { return }
                
                self.articleBookMark(articleId: articleId, isSelected: isSelected)
            }
            return cell
        case .articleTitle(let titleModel):
            let cell = TitleTableViewCell.dequeueReusableCell(to: articleTableView)
            cell.inputData = titleModel
            cell.selectionStyle = .none
            return cell
        case .editorNote(let editorModel):
            let cell = EditorTableViewCell.dequeueReusableCell(to: articleTableView)
            cell.inputData = editorModel
            cell.selectionStyle = .none
            return cell
        case .chapterTitle(let chapterTitleModel):
            let cell = ChapterTitleTableViewCell.dequeueReusableCell(to: articleTableView)
            cell.inputData = chapterTitleModel
            cell.selectionStyle = .none
            return cell
        case .body(let bodyModel):
            let cell = BodyTableViewCell.dequeueReusableCell(to: articleTableView)
            cell.inputData = bodyModel
            cell.selectionStyle = .none
            return cell
        case .generalTitle(let generalTitleModel):
            let cell = GeneralTitleTableViewCell.dequeueReusableCell(to: articleTableView)
            cell.inputData = generalTitleModel
            cell.selectionStyle = .none
            return cell
        case .image(let imageModel):
            let cell = ThumnailTableViewCell.dequeueReusableCell(to: articleTableView)
            cell.inputData = imageModel
            cell.setImageTypeCell()
            cell.selectionStyle = .none
            return cell
        case .endNote:
            let cell = CopyRightTableViewCell.dequeueReusableCell(to: articleTableView)
            cell.selectionStyle = .none
            return cell
        case .none:
            return UITableViewCell()
        }
    }

}


extension ArticleDetailViewController {
    /// Article ID를 해당 메서드로 넘긴 후에 해당 VC를 present해주세요
    /// - Parameter id: articleId
    func setArticleId(id: Int?) {
        self.articleId = id
    }
}
