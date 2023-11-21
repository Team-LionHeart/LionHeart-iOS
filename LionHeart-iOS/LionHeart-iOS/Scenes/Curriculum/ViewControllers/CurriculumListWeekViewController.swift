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
    
    private let leftButtonTapped = PassthroughSubject<Void, Never>()
    private let rightButtonTapped = PassthroughSubject<Void, Never>()
    private let articleCellTapped = PassthroughSubject<IndexPath, Never>()
    private let bookmarkButtonTapped = PassthroughSubject<IndexPath, Never>()
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let backButtonTapped = PassthroughSubject<Void, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    private lazy var navigationBar = LHNavigationBarView(type: .curriculumByWeek, viewController: self)
    private lazy var datasoruce = CurriculumListWeekDiffableDataSource(tableView: curriculumListByWeekTableView)
    private lazy var headerView = CurriculumArticleByWeekHeaderView(frame: .init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width*(200 / 375)))
    private let curriculumListByWeekTableView = CurriculumListByWeekTableView()
    
    private let viewModel: any CurriculumListWeekViewModel
    
//    var weekCount: Int?
//    var selectedIndexPath: IndexPath?
//    var inputData: CurriculumWeekData? 
//    {
//        didSet {
//            curriculumListByWeekTableView.reloadData()
//        }
//    }
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
        bindInput()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewWillAppearSubject.send(())
    }
    
    private func bindInput() {
        navigationBar.leftBarItem.tapPublisher
            .sink { [weak self] in self?.backButtonTapped.send(()) }
            .store(in: &cancelBag)
        
        headerView.curriculumWeekChangeButtonTapped
            .sink { [weak self] type in
                switch type {
                case .left:
                    self?.leftButtonTapped.send(())
                case .right:
                    self?.rightButtonTapped.send(())
                }
            }
            .store(in: &cancelBag)
    }
    
    private func bind() {
        let input = CurriculumListWeekViewModelInput(leftButtonTapped: leftButtonTapped, rightButtonTapped: rightButtonTapped, articleCellTapped: articleCellTapped, bookmarkButtonTapped: bookmarkButtonTapped, viewWillAppearSubject: viewWillAppearSubject, backButtonTapped: backButtonTapped)
        let output = viewModel.transform(input: input)
        output.articleByWeekData
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.applySnapshot(weekData: $0)
                self?.setTableView(input: $0)
                self?.navigationBar.setCurriculumWeek(week: $0.week ?? 0)
            }
            .store(in: &cancelBag)
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
    
    enum Size {
        static let weekBackGroundImageSize: CGFloat = (60 / 375) * Constant.Screen.width
    }
    
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
//        if indexPath.row != 0 {
//            
//            
//            guard let inputData else { return }
//            NotificationCenter.default.post(name: NSNotification.Name("didSelectTableViewCell"), object: inputData.articleData[indexPath.row-1].articleId)
//        }
    }
}



//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let inputData else { return 0 }
//        return inputData.articleData.count + 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = CurriculumArticleByWeekRowZeroTableViewCell.dequeueReusableCell(to: curriculumListByWeekTableView)
//            cell.inputData = inputData?.week
//            return cell
//        } else {
//            let cell = CurriculumArticleByWeekTableViewCell.dequeueReusableCell(to: curriculumListByWeekTableView)
//            cell.inputData = inputData?.articleData[indexPath.row - 1]
//            cell.selectionStyle = .none
//            cell.backgroundColor = .designSystem(.background)
//            return cell
//        }
//    }
