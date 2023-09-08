//
//  TodayViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Today. All rights reserved.
//

import UIKit

import SnapKit

final class TodayViewController: UIViewController {
    
    enum TodayArticleImage {
        static let ratio: CGFloat = 400/335
    }
    
    private var todayArticleID: Int?

    private lazy var todayNavigationBar = LHNavigationBarView(type: .today, viewController: self)
    
    private var titleLabel = LHTodayArticleTitle()
    private var subTitleLable = LHTodayArticleTitle(initalizeString: "오늘의 아티클이에요")
    private var mainArticleView = TodayArticleView()
    
    private var pointImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "TodayArticle_PointImage"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

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
                let responseArticle = try await ArticleService.shared.inquiryTodayArticle()
                let image = try await LHKingFisherService.fetchImage(with: responseArticle.mainImageURL)
                mainArticleView.mainArticlImageView.image = image
                titleLabel.userNickName = responseArticle.fetalNickname
                mainArticleView.data = responseArticle
                todayArticleID = responseArticle.aticleID
                // MARK: - 추후에 디팀에서 그라데이션있는 이미지로 받아오기로함
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

// MARK: - layout
private extension TodayViewController {
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
            let bookmarkViewController = BookmarkViewController()
            self.navigationController?.pushViewController(bookmarkViewController, animated: true)
        }
        
        todayNavigationBar.rightSecondBarItemAction {
            let wrapperClass = AuthMyPageServiceWrapper()
            let myPageViewController = MyPageViewController(service: wrapperClass)
            self.navigationController?.pushViewController(myPageViewController, animated: true)
        }
    }
    
    @objc func articleTapped(_ sender: UIButton) {
        guard let todayArticleID else { return }
        self.presentArticleDetailFullScreen(articleID: todayArticleID)
    }
}

// MARK: - 네트워킹
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
            ViewControllerUtil.setRootViewController(window: window, viewController: SplashViewController(authService: AuthService(api: AuthAPI(apiService: APIService()))), withAnimation: false)
        case .clientError(_, let message):
            LHToast.show(message: message, isTabBar: true)
        case .serverError:
            LHToast.show(message: "승준이어딧니 내목소리들리니", isTabBar: true)
        }
    }
}
