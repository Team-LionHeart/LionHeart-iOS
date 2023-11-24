//
//  CurriculumListWeekViewController.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/21/23.
//

import UIKit
import Combine

protocol CurriculumArticleByWeekControllerable where Self: UIViewController {}

final class CurriculumListWeekViewController: UIViewController, CurriculumArticleByWeekControllerable {
    
    private let leftButtonTapped = PassthroughSubject<CurriculumListWeekButtonType, Never>()
    private let rightButtonTapped = PassthroughSubject<CurriculumListWeekButtonType, Never>()
    private let articleCellTapped = PassthroughSubject<IndexPath, Never>()
    private let bookmarkButtonTapped = PassthroughSubject<(indexPath: IndexPath, isSelected: Bool), Never>()
    private let viewWillAppearSubject = PassthroughSubject<CurriculumListWeekButtonType, Never>()
    private let backButtonTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var navigationBar = LHNavigationBarView(type: .curriculumByWeek, viewController: self)
    private var datasoruce: UITableViewDiffableDataSource<CurriculumListWeekSection, CurriculumListWeekItem>!
    private lazy var headerView = CurriculumArticleByWeekHeaderView(frame: .init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width*(200 / 375)))
    private let curriculumListByWeekTableView = CurriculumListByWeekTableView()
    
    private let viewModel: any CurriculumListWeekViewModel
    
    init(viewModel: some CurriculumListWeekViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setDataSource()
        bindInput()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showLoading()
        self.viewWillAppearSubject.send(.none)
    }
    
    private func bindInput() {
        navigationBar.leftBarItem.tapPublisher
            .sink { [weak self] in self?.backButtonTapped.send(()) }
            .store(in: &cancelBag)
        
        headerView.curriculumWeekChangeButtonTapped
            .sink { [weak self] type in
                switch type {
                case .left:
                    self?.leftButtonTapped.send(.left)
                case .right:
                    self?.rightButtonTapped.send(.right)
                }
            }
            .store(in: &cancelBag)
    }
    
    private func bind() {
        let input = CurriculumListWeekViewModelInput(leftButtonTapped: leftButtonTapped,
                                                     rightButtonTapped: rightButtonTapped,
                                                     articleCellTapped: articleCellTapped,
                                                     bookmarkButtonTapped: bookmarkButtonTapped,
                                                     viewWillAppearSubject: viewWillAppearSubject,
                                                     backButtonTapped: backButtonTapped)
        let output = viewModel.transform(input: input)
        output.articleByWeekData
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.applySnapshot(weekData: $0.data)
                self?.setTableView(input: $0.data)
                self?.navigationBar.setCurriculumWeek(week: $0.data.week ?? 0)
                self?.headerView.buttonHidden(left: $0.leftButtonHidden, right: $0.rightButtonHidden)
                self?.hideLoading()
            }
            .store(in: &cancelBag)
        
        output.bookMarkCompleted
            .receive(on: RunLoop.main)
            .sink { message in
                LHToast.show(message: message)
            }
            .store(in: &cancelBag)
    }
    
    private func setDataSource() {
        self.datasoruce = UITableViewDiffableDataSource(tableView: self.curriculumListByWeekTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .article(let weekData):
                let cell = CurriculumArticleByWeekTableViewCell.dequeueReusableCell(to: tableView)
                
                cell.bookmarkSubject
                    .sink { isSelected in
                        self.bookmarkButtonTapped.send((indexPath: indexPath, isSelected: isSelected))
                    }
                    .store(in: &cell.cancelBag)
                    
                
                cell.inputData = weekData
                cell.selectionStyle = .none
                cell.backgroundColor = .designSystem(.background)
                return cell
            }
        })
        self.datasoruce.defaultRowAnimation = .fade
    }
    
    private func applySnapshot(weekData: CurriculumWeekData) {
        
        var snapshot = NSDiffableDataSourceSnapshot<CurriculumListWeekSection, CurriculumListWeekItem>()
        snapshot.appendSections([.articleListByWeek])
        
        let items = weekData.articleData.map {
            return CurriculumListWeekItem.article(weekData: $0)
        }
        
        snapshot.appendItems(items, toSection: .articleListByWeek)
        self.datasoruce.apply(snapshot)
    }
    
    private func setTableView(input: CurriculumWeekData) {
        self.headerView.inputData = input.week
        self.curriculumListByWeekTableView.tableHeaderView = self.headerView
    }
}


private extension CurriculumListWeekViewController {
    
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        self.view.addSubviews(navigationBar, curriculumListByWeekTableView)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        curriculumListByWeekTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setDelegate() {
        curriculumListByWeekTableView.delegate = self
    }
}

extension CurriculumListWeekViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.articleCellTapped.send(indexPath)
    }
}
