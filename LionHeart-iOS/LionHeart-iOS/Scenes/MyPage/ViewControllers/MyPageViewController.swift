//
//  MyPageViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 MyPage. All rights reserved.
//

import UIKit
import Combine

import SnapKit

protocol MyPageControllerable where Self: UIViewController {}

final class MyPageViewController: UIViewController, MyPageControllerable {
    
    private var viewModel: any MyPageViewModel
    private lazy var navigtaionBar = LHNavigationBarView(type: .myPage, viewController: self)
    private let myPageTableView = MyPageTableView()
    private lazy var dataSource = MyPageDataSource(tableView: myPageTableView)
    private let backButtonTapped = PassthroughSubject<Void, Never>()
    private let resignButtonTapped = PassthroughSubject<Void, Never>()
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - 회원탈퇴를 위한 임시 버튼
    private let resignButton: UIButton = {
        let button = UIButton()
        button.alpha = 0.1
        return button
    }()

    init(viewModel: some MyPageViewModel) {
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
        hiddenNavigationBar()
        setTabbar()
        bindInput()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSubject.send(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setTableViewHeader(_ input: BadgeProfileAppData) {
        let headerView = MyPageUserInfoView(frame: .init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width*(224/360)))
        headerView.inputData = input
        myPageTableView.tableHeaderView = headerView
    }
}

private extension MyPageViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(navigtaionBar, myPageTableView, resignButton)
    }
    
    func setLayout() {
        resignButton.backgroundColor = .designSystem(.lionRed)
        navigtaionBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        myPageTableView.snp.makeConstraints {
            $0.top.equalTo(navigtaionBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        resignButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.width.equalTo(50)
        }
    }
    
    func setDelegate() {
        myPageTableView.delegate = self
    }
    
    func hiddenNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func bindInput() {
        self.navigtaionBar.leftBarItem.tapPublisher
            .sink { [weak self] in self?.backButtonTapped.send(()) }
            .store(in: &cancelBag)
        
        self.resignButton.tapPublisher
            .sink { [weak self] in self?.resignButtonTapped.send(()) }
            .store(in: &cancelBag)
    }
    
    func bind() {
        let input = MyPageViewModelInput(backButtonTapped: backButtonTapped, resignButtonTapped: resignButtonTapped, viewWillAppearSubject: viewWillAppearSubject)
        let output = viewModel.transform(input: input)
        output.viewWillAppearSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.setTableViewHeader($0.profileData)
                self?.dataSource.makeList($0.appSettingData, $0.customerServiceData)
            }
            .store(in: &cancelBag)
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            switch item {
            case .appSettingRow(section: _):
                return tableView.frame.width*(62/360)
            case .customerServiceRow(section: _):
                return tableView.frame.width*(52/360)
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageTableSectionHeaderView.identifier) as? MyPageTableSectionHeaderView else { return MyPageTableSectionHeaderView() }
        cell.inputData = MyPageSection.allCases[section].rawValue
        return cell
    }
}
