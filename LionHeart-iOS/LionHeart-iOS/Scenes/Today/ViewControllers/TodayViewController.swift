//
//  TodayViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Today. All rights reserved.
//

import UIKit

import SnapKit

protocol TodayManager {
    func inquiryTodayArticle() async throws -> TodayArticle
}

final class TodayViewController: UIViewController {
    
    private let manager: TodayManager
    
    private lazy var todayNavigationBar = LHNavigationBarView(type: .today, viewController: self)
    private var titleLabel = LHTodayArticleTitle()
    private var subTitleLable = LHTodayArticleTitle(initalizeString: "오늘의 아티클이에요")
    private var mainArticleView = TodayArticleView()
    private var pointImage = LHImageView(in: UIImage(named: "TodayArticle_PointImage"), contentMode: .scaleAspectFit)
    
    private var todayArticleID: Int?
    
    init(manager: TodayManager) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
        setHierarchy()
        setLayout()
        setTapGesture()
        setButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showLoading()
        getInquireTodayArticle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mainArticleView.mainArticlImageView.removeGradient()
    }
}

extension TodayViewController {
    func getInquireTodayArticle() {
        Task {
            do {
                let responseArticle = try await manager.inquiryTodayArticle()
                let image = try await LHKingFisherService.fetchImage(with: responseArticle.mainImageURL)
                mainArticleView.mainArticlImageView.image = image
                titleLabel.userNickName = responseArticle.fetalNickname
                mainArticleView.data = responseArticle
                todayArticleID = responseArticle.aticleID
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.hideLoading()
                }
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}

private extension TodayViewController {
    enum TodayArticleImage {
        static let ratio: CGFloat = 400/335
    }
    
    func setUI() {
        view.backgroundColor = .designSystem(.black)
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(todayNavigationBar)
        view.addSubviews(titleLabel, subTitleLable, pointImage, mainArticleView)
    }
    
    func setLayout() {
        todayNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(todayNavigationBar.snp.bottom).offset(53)
            make.leading.equalToSuperview().inset(20)
        }
        
        subTitleLable.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        pointImage.snp.makeConstraints { make in
            make.top.equalTo(subTitleLable.snp.top)
            make.leading.equalTo(subTitleLable.snp.trailing).offset(4)
            make.size.equalTo(10)
        }
        
        mainArticleView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLable.snp.bottom).offset(28)
            make.width.equalTo(ScreenUtils.getWidth(335))
            make.centerX.equalToSuperview()
            make.height.equalTo(mainArticleView.snp.width).multipliedBy(TodayArticleImage.ratio)
        }
    }
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(articleTapped(_:)))
        mainArticleView.addGestureRecognizer(tapGesture)
    }

    func setButtonAction() {
        todayNavigationBar.rightFirstBarItemAction {
            let bookmarkViewController = BookmarkViewController(manager: BookmarkMangerImpl(bookmarkService: BookmarkServiceImpl(apiService: APIService())))
            self.navigationController?.pushViewController(bookmarkViewController, animated: true)
        }
        
        todayNavigationBar.rightSecondBarItemAction {
            let myPageViewController = MyPageViewController(manager: MyPageManagerImpl(mypageService: MyPageServiceImpl(apiService: APIService()), authService: AuthServiceImpl(apiService: APIService())))
            self.navigationController?.pushViewController(myPageViewController, animated: true)
        }
    }
    
    @objc func articleTapped(_ sender: UIButton) {
        guard let todayArticleID else { return }
        self.presentArticleDetailFullScreen(articleID: todayArticleID)
    }
}

extension TodayViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .urlEncodingError:
            LHToast.show(message: "URL인코딩오류입니다", isTabBar: true)
        case .jsonDecodingError:
            LHToast.show(message: "Json디코딩오류입니다", isTabBar: true)
        case .badCasting:
            LHToast.show(message: "배드퀘스트", isTabBar: true)
        case .fetchImageError:
            LHToast.show(message: "이미지패치실패", isTabBar: true)
        case .unAuthorizedError:
            guard let window = self.view.window else { return }
            let splashViewController = SplashViewController(manager: SplashManagerImpl(authService: AuthServiceImpl(apiService: APIService())))
            ViewControllerUtil.setRootViewController(window: window, viewController: splashViewController, withAnimation: false)
        case .clientError(_, let message):
            LHToast.show(message: message, isTabBar: true)
        case .serverError:
            LHToast.show(message: error.description, isTabBar: true)
        }
    }
}
