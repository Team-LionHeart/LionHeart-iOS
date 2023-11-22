//
//  CurriculumViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Curriculum. All rights reserved.
//

import UIKit
import Combine

import SnapKit
import Lottie

protocol CurriculumControllerable where Self: UIViewController {}

final class CurriculumViewController: UIViewController, CurriculumControllerable  {
    
//    var navigator: CurriculumNavigation
//    private let manager: CurriculumManager
    private let viewDidLayoutSubviewSubject = PassthroughSubject<Void, Never>()
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let bookmarkButtonTapped = PassthroughSubject<Void, Never>()
    private let myPageButtonTapped = PassthroughSubject<Void, Never>()
    private let rightArrowButtonTapped = PassthroughSubject<Int, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    private var datasource: UITableViewDiffableDataSource<CurriculumViewSection, CurriculumViewItem>!

    private lazy var navigationBar = LHNavigationBarView(type: .curriculumMain, viewController: self)
    private let progressBar = LHLottie()
    private let dDayLabel = LHLabel(type: .body3R, color: .gray400)
    private let dDayView = UIView()
    private lazy var curriculumUserInfoView = CurriculumUserInfoView()
    private let gradientImage = LHImageView(in: ImageLiterals.Curriculum.gradient, contentMode: .scaleToFill)
    private let curriculumTableView = CurriculumTableView()
    
    private let viewModel: any CurriculumViewViewModel
//    private var isFirstPresented: Bool = true
//    private var curriculumViewDatas = CurriculumMonthData.dummy()
//    private var userInfoData: UserInfoData? {
//        didSet {
//            configureUserInfoData()
//        }
//    }
    
    init(viewModel: some CurriculumViewViewModel) {
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
//        setDelegate()
        setDataSource()
        bindInput()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        self.viewDidLayoutSubviewSubject.send(())
//        if isFirstPresented {
//            self.scrollToUserWeek()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showLoading()
//        getCurriculumData()
        self.viewWillAppearSubject.send(())
    }
    
    private func bindInput() {
        navigationBar.rightFirstBarItem
            .tapPublisher
            .sink { [weak self] _ in
                self?.bookmarkButtonTapped.send(())
            }
            .store(in: &cancelBag)
        
        navigationBar.rightSecondBarItem
            .tapPublisher
            .sink { [weak self] _ in
                self?.myPageButtonTapped.send(())
            }
            .store(in: &cancelBag)
    }
    
    private func bind() {
        let input = CurriculumViewViewModelInput(viewDidLayoutSubviews: viewDidLayoutSubviewSubject,
                                                 viewWillAppear: viewWillAppearSubject,
                                                 bookmarkButtonTapped: bookmarkButtonTapped,
                                                 myPageButtonTapped: myPageButtonTapped,
                                                 rightArrowButtonTapped: rightArrowButtonTapped)
        let output = viewModel.transform(input: input)
        output.curriculumMonth
            .sink { [weak self] monthData in
                self?.applySnapshot(monthData: monthData)
            }
            .store(in: &cancelBag)
        
        output.firstScrollIndexPath
            .sink { [weak self] indexPath in
                self?.scrollToUserWeek(indexPath: indexPath)
            }
            .store(in: &cancelBag)
    }
    
    private func setDataSource() {
        self.datasource = UITableViewDiffableDataSource(tableView: self.curriculumTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .article(let weekData):
                let cell = CurriculumTableViewCell.dequeueReusableCell(to: tableView)
                
                cell.toggleButtonTapped
                    .sink { [weak self] _ in
                        self?.toggleButtonTapped(indexPath: indexPath)
                    }
                    .store(in: &self.cancelBag)
                
                cell.rightArrowButtonTapped
                    .sink { [weak self] _ in
                        self?.moveToListByWeekButtonTapped(indexPath: indexPath)
                    }
                    .store(in: &self.cancelBag)
                
                cell.inputData = weekData
                cell.selectionStyle = .none
                
//                let data = curriculumViewDatas[indexPath.section].weekDatas[indexPath.row]
//                cell.delegate = self
//                cell.cellIndexPath = indexPath
                
                cell.curriculumToggleDirectionButton.isSelected = weekData.isExpanded
                return cell
            }
        })
    }
    
    private func applySnapshot(monthData: [CurriculumMonthData]) {
        var snapshot = NSDiffableDataSourceSnapshot<CurriculumViewSection, CurriculumViewItem>()
        CurriculumViewSection.allCases.forEach {
            snapshot.appendSections([$0])
        }
        
        let items = monthData.flatMap { data in
            return data.weekDatas.map {
                return CurriculumViewItem.article(weekData: $0)
            }
        }
        snapshot.appendItems(items, toSection: .month2)
        self.datasource.apply(snapshot)
    }
}

private extension CurriculumViewController {
    
    enum Size {
        static let userInfoView: CGFloat = 70 / 375
    }
    
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        dDayView.addSubview(dDayLabel)
        view.addSubviews(navigationBar, progressBar, curriculumUserInfoView, curriculumTableView, gradientImage, dDayView)
    }
    
    func setLayout() {
        self.navigationController?.isNavigationBarHidden = true
        navigationBar.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        dDayView.snp.makeConstraints{
            $0.size.equalTo(100)
            $0.leading.equalToSuperview().inset(48)
            $0.centerY.equalTo(progressBar)
        }
        
        dDayLabel.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        curriculumUserInfoView.snp.makeConstraints{
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(Constant.Screen.width)
            $0.height.equalTo(curriculumUserInfoView.snp.width).multipliedBy(Size.userInfoView)
        }
        
        progressBar.snp.makeConstraints{
            $0.top.equalTo(curriculumUserInfoView.snp.bottom)
            $0.trailing.leading.equalToSuperview()
            $0.width.equalTo(Constant.Screen.width)
            $0.height.equalTo(ScreenUtils.getHeight(180))
        }
        
        curriculumTableView.snp.makeConstraints{
            $0.top.equalTo(progressBar.snp.bottom)
            $0.trailing.bottom.leading.equalToSuperview()
        }
        
        gradientImage.snp.makeConstraints{
            $0.top.equalTo(progressBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
//    func setDelegate() {
//        curriculumTableView.dataSource = self
//    }
    
    func scrollToUserWeek(indexPath: IndexPath) {
        self.curriculumTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        
    }
    
    func configureUserInfoData() {
        guard let userInfoData else { return }
        dDayLabel.text = "D-\(userInfoData.remainingDay)"
        let progressName: String = "progressbar_\(userInfoData.progress)m"
        progressBar.animation = .named(progressName)
        progressBar.play()
        curriculumUserInfoView.userInfo = userInfoData
    }
}

//extension CurriculumViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return curriculumViewDatas[section].weekDatas.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = CurriculumTableViewCell.dequeueReusableCell(to: tableView)
//        let data = curriculumViewDatas[indexPath.section].weekDatas[indexPath.row]
//        cell.inputData = data
//        cell.selectionStyle = .none
////        cell.delegate = self
//        cell.cellIndexPath = indexPath
//        cell.curriculumToggleDirectionButton.isSelected = data.isExpanded
//        return cell
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return curriculumViewDatas.count
//    }
//}

extension CurriculumViewController {
    func toggleButtonTapped(indexPath: IndexPath?) {
        self.isFirstPresented = false
        guard let indexPath  else { return }
        let previousWeekDatas = curriculumViewDatas[indexPath.section].weekDatas[indexPath.row]
        curriculumViewDatas[indexPath.section].weekDatas[indexPath.row].isExpanded = !previousWeekDatas.isExpanded
        curriculumTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func moveToListByWeekButtonTapped(indexPath: IndexPath?) {
        guard let indexPath else { return }
        let itemIndex = indexPath.section * 4 + indexPath.row + 4
        self.navigator.articleListCellTapped(itemIndex: itemIndex)
    }
}

//extension CurriculumViewController: ViewControllerServiceable {
//    func handleError(_ error: NetworkError) {
//        switch error {
//        case .unAuthorizedError:
//            self.navigator.checkTokenIsExpired()
//        case .clientError(_, let message):
//            LHToast.show(message: "\(message)")
//        default:
//            LHToast.show(message: error.description)
//        }
//    }
//}

//extension CurriculumViewController {
//    func getCurriculumData() {
//        Task {
//            do {
//                userInfoData = try await manager.getCurriculumServiceInfo()
//                hideLoading()
//            } catch {
//                guard let error = error as? NetworkError else { return }
//                handleError(error)
//            }
//        }
//    }
//}
