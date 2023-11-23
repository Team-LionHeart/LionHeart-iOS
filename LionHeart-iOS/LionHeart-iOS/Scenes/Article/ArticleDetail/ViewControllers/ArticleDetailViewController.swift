//
//  ArticleDetailViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 ArticleDetail. All rights reserved.
//

import UIKit
import Combine

import SnapKit

protocol ArticleControllerable where Self: UIViewController {}

final class ArticleDetailViewController: UIViewController, ArticleControllerable {
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let closeButtonTapped = PassthroughSubject<Void, Never>()
    private let bookmarkButtonTapped = PassthroughSubject<Void, Never>()
    private let scrollToTopButtonTapped = PassthroughSubject<Void, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    private let viewModel: any ArticleDetailViewModel
    
    private var datasource: UITableViewDiffableDataSource<ArticleDetailSection, BlockTypeAppData>!
    
    private lazy var navigationBar = LHNavigationBarView(type: .articleMain, viewController: self)
    private var progressBar = LHProgressView()
    private let articleTableView = ArticleDetailTableView()
    private let scrollToTopButton = LHImageButton(setImage: ImageLiterals.Article.icFab)
    
    init(viewModel: some ArticleDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setUI()
        setHierarchy()
        setLayout()
        setTableView()
        setNavigationBar()
        setTabbar()
        bindInput()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSubject.send(())
        showLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func bindInput() {
        scrollToTopButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.scrollToTopButtonTapped.send(())
            }
            .store(in: &cancelBag)
        
        navigationBar.leftBarItem.tapPublisher
            .sink { _ in
                self.closeButtonTapped.send(())
            }
            .store(in: &cancelBag)
    }
    
    private func bind() {
        let input = ArticleDetailViewModelInput(viewWillAppear: viewWillAppearSubject,
                                                closeButtonTapped: closeButtonTapped,
                                                bookmarkButtonTapped: bookmarkButtonTapped,
                                                scrollToTopButtonTapped: scrollToTopButtonTapped)
        let output = viewModel.transform(input: input)
        output.articleDetail
            .receive(on: RunLoop.main)
            .sink { [weak self] article in
                guard let self else { return }
                self.hideLoading()
                
                self.setDatasource(blockTypes: article.blockTypes,
                                   isBookMarked: article.isMarked)
                self.applySnapshot(article.blockTypes)
            }
            .store(in: &cancelBag)
        
        output.bookmarkCompleted
            .sink { str in
                print(str)
            }
            .store(in: &cancelBag)
        
        output.scrollToTopButtonTapped
            .sink { _ in
                let indexPath = IndexPath(row: 0, section: 0)
                self.articleTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                self.scrollToTopButton.isHidden = true
            }
            .store(in: &cancelBag)
    }
}

extension ArticleDetailViewController {
    private func setDatasource(blockTypes: [BlockTypeAppData], isBookMarked: Bool) {
        self.datasource = UITableViewDiffableDataSource(tableView: self.articleTableView,
                                                        cellProvider: { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .thumbnail(let isMarked, let thumbnailModel):
                let cell = ThumnailTableViewCell.dequeueReusableCell(to: self.articleTableView)
                cell.inputData = thumbnailModel
                cell.selectionStyle = .none
                
                cell.bookMarkButton.tapPublisher
                    .sink { [weak self] _ in
                        cell.isMarked?.toggle()
                        self?.bookmarkButtonTapped.send(())
                    }
                    .store(in: &self.cancelBag)

                if isBookMarked {
                    cell.isMarked = isBookMarked
                } else {
                    cell.isMarked = isMarked
                }
                cell.setThumbnailImageView()
                return cell
            case .articleTitle(let titleModel):
                let cell = TitleTableViewCell.dequeueReusableCell(to: self.articleTableView)
                cell.inputData = titleModel
                cell.selectionStyle = .none
                return cell
            case .editorNote(let editorModel):
                let cell = EditorTableViewCell.dequeueReusableCell(to: self.articleTableView)
                cell.inputData = editorModel
                cell.selectionStyle = .none
                return cell
            case .chapterTitle(let chapterTitleModel):
                let cell = ChapterTitleTableViewCell.dequeueReusableCell(to: self.articleTableView)
                cell.inputData = chapterTitleModel
                cell.selectionStyle = .none
                return cell
            case .body(let bodyModel):
                let cell = BodyTableViewCell.dequeueReusableCell(to: self.articleTableView)
                cell.inputData = bodyModel
                cell.selectionStyle = .none
                return cell
            case .generalTitle(let generalTitleModel):
                let cell = GeneralTitleTableViewCell.dequeueReusableCell(to: self.articleTableView)
                cell.inputData = generalTitleModel
                cell.selectionStyle = .none
                return cell
            case .image(let imageModel):
                let cell = ThumnailTableViewCell.dequeueReusableCell(to: self.articleTableView)
                cell.inputData = imageModel
                cell.setImageTypeCell()
                cell.selectionStyle = .none
                return cell
            case .endNote:
                let cell = CopyRightTableViewCell.dequeueReusableCell(to: self.articleTableView)
                cell.selectionStyle = .none
                return cell
            case .none:
                return UITableViewCell()
            }
        })
    }
    
    func applySnapshot(_ blocks: [BlockTypeAppData]) {
        var snapshot = NSDiffableDataSourceSnapshot<ArticleDetailSection, BlockTypeAppData>()
        snapshot.appendSections([.articleMain])
        snapshot.appendItems(blocks)
        self.datasource.apply(snapshot, animatingDifferences: false)
    }
}

private extension ArticleDetailViewController {

    func setStyle() {
        self.view.backgroundColor = .designSystem(.background)
    }
    
    func setUI() {
        view.backgroundColor = .designSystem(.background)
        scrollToTopButton.isHidden = true
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
        if velocity.y <= 0 {
            self.scrollToTopButton.isHidden = false
        } else {
            self.scrollToTopButton.isHidden = true
        }
    }
}
