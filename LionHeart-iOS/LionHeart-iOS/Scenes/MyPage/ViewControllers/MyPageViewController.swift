//
//  MyPageViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 MyPage. All rights reserved.
//

import UIKit

import SnapKit

protocol MyPageServiceProtocol: AnyObject {
    func getMyPage() async throws -> MyPageAppData
    func resignUser() async throws
    func logout(token: UserDefaultToken) async throws
}

final class MyPageViewController: UIViewController {

    // MARK: - Properties
    
    private let myPageServiceLabelList = MyPageLocalData.myPageServiceLabelList
    private let myPageSectionLabelList = MyPageLocalData.myPageSectionLabelList
    private let myPageAppSettingLabelList = MyPageAppSettinLocalgData.myPageAppSettingDataList
    
    private var myPageAppData: MyPageAppData? {
        didSet {
            myPageCollectionView.reloadData()
        }
    }

    private let service: MyPageServiceProtocol

    // MARK: - UI Components
    
    private lazy var navigtaionBar = LHNavigationBarView(type: .myPage, viewController: self)

    private let myPageCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let resignButton: UIButton = {
        let button = UIButton()
        button.alpha = 0.1
        return button
    }()

    init(service: MyPageServiceProtocol) {
        self.service = service
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
        
        Task {
            do {
                let data = try await service.getMyPage()
                myPageAppData = data
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
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
                    try await self.service.resignUser()
                    ViewControllerUtil.setRootViewController(window: window, viewController: SplashViewController(authService: AuthMyPageServiceWrapper(authAPIService: AuthAPI(apiService: APIService()), mypageAPIService: MyPageAPI(apiService: APIService()))), withAnimation: false)
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
            ViewControllerUtil.setRootViewController(window: window, viewController: SplashViewController(authService: AuthMyPageServiceWrapper(authAPIService: AuthAPI(apiService: APIService()), mypageAPIService: MyPageAPI(apiService: APIService()))), withAnimation: false)
        case .clientError(_, let message):
            LHToast.show(message: message)
        case .serverError:
            LHToast.show(message: error.description)
        }
    }
}

extension MyPageViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return myPageServiceLabelList.count
        } else {
            return myPageAppSettingLabelList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = MyPageProfileCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.inputData = myPageAppData
            return cell
        } else if indexPath.section == 1 {
            let cell = MyPageCustomerServiceCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.inputData = myPageServiceLabelList[indexPath.item]
            return cell
        } else {
            let cell = MyPageAppSettingCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.inputData = myPageAppSettingLabelList[indexPath.item]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            return UICollectionReusableView()
        }
        let headerView = MyPageHeaderView.dequeueReusableheaderView(to: collectionView, viewForSupplementaryElementOfKind: kind, indexPath: indexPath)
        headerView.inputData = myPageSectionLabelList[indexPath.section-1]
        return headerView
    }
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(224/360))
        } else if indexPath.section == 1 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(52/360))
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(62/360))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        section == 2 ? UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0) : UIEdgeInsets(top: 0, left: 0, bottom: 36, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        section == 0 ? CGSize() : CGSize(width: collectionView.frame.width, height: collectionView.frame.width*(36/360))
    }
}
