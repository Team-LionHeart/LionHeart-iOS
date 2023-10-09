//
//  MyPageViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 MyPage. All rights reserved.
//

import UIKit

import SnapKit

protocol MyPageManager {
    func getMyPage() async throws -> BadgeProfileAppData
    func resignUser() async throws
    func logout(token: UserDefaultToken) async throws
}

final class MyPageViewController: UIViewController {
    
    private let manager: MyPageManager
    
    private lazy var navigtaionBar = LHNavigationBarView(type: .myPage, viewController: self)
    private let myPageCollectionView = LHCollectionView(color: .background)
    
    private var sections = MyPageSection.sectionArray
    private var badgeProfileAppData = BadgeProfileAppData.empty {
        didSet {
            myPageCollectionView.reloadData()
        }
    }
    
    // MARK: - 회원탈퇴를 위한 임시 버튼
    private let resignButton: UIButton = {
        let button = UIButton()
        button.alpha = 0.1
        return button
    }()

    init(manager: MyPageManager) {
        self.manager = manager
        
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
        registerCell()
        hiddenNavigationBar()
        setTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIFromNetworking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

private extension MyPageViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(navigtaionBar, myPageCollectionView, resignButton)
    }
    
    func setLayout() {
        navigtaionBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        myPageCollectionView.snp.makeConstraints {
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
        resignButton.addButtonAction { sender in
            Task {
                do {
                    guard let window = self.view.window else { return }
                    self.resignButton.isUserInteractionEnabled = false
                    try await self.manager.resignUser()
                    let splashViewController = SplashViewController(manager: SplashManagerImpl(authService: AuthServiceImpl(apiService: APIService())))
                    ViewControllerUtil.setRootViewController(window: window, viewController: splashViewController, withAnimation: false)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func setDelegate() {
        myPageCollectionView.delegate = self
        myPageCollectionView.dataSource = self
    }
    
    func registerCell() {
        MyPageProfileCollectionViewCell.register(to: myPageCollectionView)
        MyPageCustomerServiceCollectionViewCell.register(to: myPageCollectionView)
        MyPageAppSettingCollectionViewCell.register(to: myPageCollectionView)
        MyPageHeaderView.registerHeaderView(to: myPageCollectionView)
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
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}

extension MyPageViewController: ViewControllerServiceable {
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
            let splashViewController = SplashViewController(manager: SplashManagerImpl(authService: AuthServiceImpl(apiService: APIService())))
            ViewControllerUtil.setRootViewController(window: window, viewController: splashViewController, withAnimation: false)
        case .clientError(_, let message):
            LHToast.show(message: message)
        case .serverError:
            LHToast.show(message: error.description)
        }
    }
}

extension MyPageViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .badgeSection:
            return 1
        case .customerServiceSetion(let sectionArray):
            return sectionArray.cellTitle.count
        case .appSettingSection(let sectionArray):
            return sectionArray.cellTitle.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .badgeSection:
            let cell = MyPageProfileCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.inputData = badgeProfileAppData
            return cell
        case .customerServiceSetion(let section):
            let cell = MyPageCustomerServiceCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.inputData = section.cellTitle[indexPath.item]
            return cell
        case .appSettingSection(let section):
            let cell = MyPageAppSettingCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.inputData = section.cellTitle[indexPath.item]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch sections[indexPath.section] {
        case .badgeSection:
            return UICollectionReusableView()
        case .customerServiceSetion(let section):
            let headerView = MyPageHeaderView.dequeueReusableheaderView(to: collectionView, viewForSupplementaryElementOfKind: kind, indexPath: indexPath)
            headerView.inputData = section.sectionTitle
            return headerView
        case .appSettingSection(let section):
            let headerView = MyPageHeaderView.dequeueReusableheaderView(to: collectionView, viewForSupplementaryElementOfKind: kind, indexPath: indexPath)
            headerView.inputData = section.sectionTitle
            return headerView
        }
    }
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case .badgeSection:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(224/360))
        case .customerServiceSetion:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(52/360))
        case .appSettingSection:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(62/360))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch sections[section] {
        case .badgeSection, .customerServiceSetion:
            return UIEdgeInsets(top: 0, left: 0, bottom: 36, right: 0)
        case .appSettingSection:
            return UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch sections[section] {
        case .badgeSection:
            return CGSize()
        case .customerServiceSetion, .appSettingSection:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(36/360))
        }
    }
}
