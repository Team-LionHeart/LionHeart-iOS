//
//  MyPageViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 MyPage. All rights reserved.
//

import UIKit

import SnapKit

final class MyPageViewController: UIViewController, MyPageControllerable {

    var adaptor: MyPageNavigation
    private let manager: MyPageManager
    
    private lazy var navigtaionBar = LHNavigationBarView(type: .myPage, viewController: self)
    private let myPageTableView = MyPageTableView()
    
    private lazy var dataSource = MyPageDataSource(tableView: myPageTableView)
    
    private var badgeProfileAppData = BadgeProfileAppData.empty {
        didSet {
            myPageTableView.reloadData()
        }
    }
    
    // MARK: - 회원탈퇴를 위한 임시 버튼
    private let resignButton: UIButton = {
        let button = UIButton()
        button.alpha = 0.1
        return button
    }()

    init(manager: MyPageManager, adaptor: MyPageNavigation) {
        self.manager = manager
        self.adaptor = adaptor
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
        setAddTarget()
        setDelegate()
        hiddenNavigationBar()
        setTabbar()
//        dataSource = UITableViewDiffableDataSource<MyPageSection, MyPageRow>(tableView: myPageTableView, cellProvider: { tableView, indexPath, itemIdentifier in
//            switch itemIdentifier {
//            case .customerServiceSetion(section: let model):
//                let cell = MyPageCustomerServiceTableViewCell.dequeueReusableCell(to: tableView)
//                cell.selectionStyle = .none
//                cell.inputData = model.cellTitle
//
//                return cell
//            case .appSettingSection(section: let model):
//                let cell = MyPageAppSettingTableViewCell.dequeueReusableCell(to: tableView)
//                cell.selectionStyle = .none
//                cell.inputData = model.cellTitle
//                return cell
//            }
//        })
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIFromNetworking()
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
    
    func setAddTarget() {
        navigtaionBar.backButtonAction {
            self.adaptor.backButtonTapped()
        }
        
        resignButton.addButtonAction { _ in
            Task {
                do {
                    self.resignButton.isUserInteractionEnabled = false
                    try await self.manager.resignUser()
                    self.adaptor.checkTokenIsExpired()
                } catch {
                    print(error)
                }
            }
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
    
    func setUIFromNetworking() {
        Task {
            do {
                let data = try await manager.getMyPage()
                badgeProfileAppData = data
                setTableViewHeader(data)
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}
//
//extension MyPageViewController: ViewControllerServiceable {
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
//            adaptor.checkTokenIsExpired()
//        case .clientError(_, let message):
//            LHToast.show(message: message)
//        case .serverError:
//            LHToast.show(message: error.description)
//        }
//    }
//}

//extension MyPageViewController: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return sections.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch sections[section] {
//        case .badgeSection:
//            return 1
//        case .customerServiceSetion(let sectionArray):
//            return sectionArray.cellTitle.count
//        case .appSettingSection(let sectionArray):
//            return sectionArray.cellTitle.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch sections[indexPath.section] {
//        case .badgeSection:
//            let cell = MyPageProfileCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
//            cell.inputData = badgeProfileAppData
//            return cell
//        case .customerServiceSetion(let section):
//            let cell = MyPageCustomerServiceCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
//            cell.inputData = section.cellTitle[indexPath.item]
//            return cell
//        case .appSettingSection(let section):
//            let cell = MyPageAppSettingCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
//            cell.inputData = section.cellTitle[indexPath.item]
//            return cell
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch sections[indexPath.section] {
//        case .badgeSection:
//            return UICollectionReusableView()
//        case .customerServiceSetion(let section):
//            let headerView = MyPageHeaderView.dequeueReusableheaderView(to: collectionView, viewForSupplementaryElementOfKind: kind, indexPath: indexPath)
//            headerView.inputData = section.sectionTitle
//            return headerView
//        case .appSettingSection(let section):
//            let headerView = MyPageHeaderView.dequeueReusableheaderView(to: collectionView, viewForSupplementaryElementOfKind: kind, indexPath: indexPath)
//            headerView.inputData = section.sectionTitle
//            return headerView
//        }
//    }
//}

extension MyPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            switch item {
            case .appSettingSection(section: _):
                return tableView.frame.width*(62/360)
            case .customerServiceSetion(section: _):
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
        cell.inputData = self.dataSource.snapshot().sectionIdentifiers[section].rawValue
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        switch sections[indexPath.section] {
//        case .badgeSection:
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(224/360))
//        case .customerServiceSetion:
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(52/360))
//        case .appSettingSection:
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(62/360))
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        switch sections[section] {
//        case .badgeSection, .customerServiceSetion:
//            return UIEdgeInsets(top: 0, left: 0, bottom: 36, right: 0)
//        case .appSettingSection:
//            return UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        switch sections[section] {
//        case .badgeSection:
//            return CGSize()
//        case .customerServiceSetion, .appSettingSection:
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(36/360))
//        }
//    }
}
