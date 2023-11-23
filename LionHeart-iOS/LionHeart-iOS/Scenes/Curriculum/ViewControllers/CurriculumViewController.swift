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
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let bookmarkButtonTapped = PassthroughSubject<Void, Never>()
    private let myPageButtonTapped = PassthroughSubject<Void, Never>()
    private let rightArrowButtonTapped = PassthroughSubject<IndexPath, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    private var datasource: UITableViewDiffableDataSource<CurriculumMonthData, CurriculumDummyData>!

    private lazy var navigationBar = LHNavigationBarView(type: .curriculumMain, viewController: self)
    private let progressBar = LHLottie()
    private let dDayLabel = LHLabel(type: .body3R, color: .gray400)
    private let dDayView = UIView()
    private lazy var curriculumUserInfoView = CurriculumUserInfoView()
    private let gradientImage = LHImageView(in: ImageLiterals.Curriculum.gradient, contentMode: .scaleToFill)
    private let curriculumTableView = CurriculumTableView()
    
    private let viewModel: any CurriculumViewViewModel

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
        setNavigation()
        setHierarchy()
        setLayout()
        setDelegate()
        setDataSource()
        bindInput()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showLoading()
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
        let input = CurriculumViewViewModelInput(viewWillAppear: viewWillAppearSubject,
                                                 bookmarkButtonTapped: bookmarkButtonTapped,
                                                 myPageButtonTapped: myPageButtonTapped,
                                                 rightArrowButtonTapped: rightArrowButtonTapped)
        let output = viewModel.transform(input: input)
        output.curriculumMonth
            .receive(on: RunLoop.main)
            .sink { [weak self] monthData in
                self?.applySnapshot(monthData: monthData.monthData)
                self?.configureUserInfoData(userInfoData: monthData.userInfo)
                self?.hideLoading()
            }
            .store(in: &cancelBag)
    }
    
    private func setDataSource() {
        self.datasource = UITableViewDiffableDataSource(tableView: self.curriculumTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = CurriculumTableViewCell.dequeueReusableCell(to: tableView)
            cell.rightArrowButtonTapped
                .sink { [weak self] _ in
                    self?.rightArrowButtonTapped.send(indexPath)
                }
                .store(in: &cell.cancelBag)
            cell.inputData = itemIdentifier
            cell.selectionStyle = .none
            return cell
        })
    }
    
    private func applySnapshot(monthData: [CurriculumMonthData]) {
        var snapshot = NSDiffableDataSourceSnapshot<CurriculumMonthData, CurriculumDummyData>()
        monthData.forEach { month in
            snapshot.appendSections([month])
            snapshot.appendItems(month.weekDatas, toSection: month)
        }
        self.datasource.defaultRowAnimation = .middle
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
    
    func setNavigation() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        dDayView.addSubview(dDayLabel)
        view.addSubviews(navigationBar, progressBar, curriculumUserInfoView, curriculumTableView, gradientImage, dDayView)
    }
    
    func setLayout() {
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
    
    func setDelegate() {
        curriculumTableView.delegate = self
    }
    
    func configureUserInfoData(userInfoData: UserInfoData?) {
        guard let userInfoData else { return }
        dDayLabel.text = "D-\(userInfoData.remainingDay)"
        let progressName: String = "progressbar_\(userInfoData.progress)m"
        progressBar.animation = .named(progressName)
        progressBar.play()
        curriculumUserInfoView.userInfo = userInfoData
    }
}

extension CurriculumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = datasource.snapshot().sectionIdentifiers[section]
        let headerView = CurriculumTableViewHeaderView()
        headerView.configureHeaderView(month: sectionModel.month)
        return headerView
    }
}
