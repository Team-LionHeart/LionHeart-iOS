//
//  ChallengeViewController.swift
//  LionHeart-iOS
//
//  Created by 김의성 on 2023/09/24.
//  Copyright (c) 2023 Challenge. All rights reserved.
//

import UIKit

import SnapKit
import Lottie

final class ChallengeViewController: UIViewController, ChallengeViewControllerable {
    
    weak var coordinator: ChallengeNavigation?
    private var manager: ChallengeManager
    
    private let leftSeperateLine = LHUnderLine(lineColor: .background)
    private let rightSeperateLine = LHUnderLine(lineColor: .background)
    private lazy var navigationBar = LHNavigationBarView(type: .challenge, viewController: self)
    private let nicknameLabel = LHLabel(type: .body2R, color: .gray200)
    private let challengeDayLabel = LHLabel(type: .head3, color: .white)
    private let challengelevelLabel = LHLabel(type: .body4, color: .gray500)
    private let levelBadge = LHImageView(in: ImageLiterals.ChallengeBadge.level05, contentMode: .scaleToFill)
    private lazy var lottieImageView = LHLottie()
    private let challengeDayCheckCollectionView = LHCollectionView()
    
    private var inputData: ChallengeData? {
        didSet {
            guard let inputData else { return }
            configureData(inputData)
        }
    }
    
    init(manager: ChallengeManager) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIFromNetworking()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setNavigationBar()
        setDelegate()
        setAddTarget()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        leftSeperateLine.setGradient(firstColor: .designSystem(.gray800)!, secondColor: .designSystem(.gray400)!, axis: .horizontal)
        rightSeperateLine.setGradient(firstColor: .designSystem(.gray400)!, secondColor: .designSystem(.gray800)!, axis: .horizontal)
    }
}

private extension ChallengeViewController {
    func configureData(_ input: ChallengeData) {
        self.nicknameLabel.text = "\(input.babyDaddyName)아빠 님,"
        self.challengeDayLabel.text = "\(input.howLongDay)일째 도전 중"
        self.levelBadge.image = BadgeLevel(rawValue: input.daddyLevel)!.badgeImage
        self.lottieImageView.animation = .named(BadgeLevel(rawValue: input.daddyLevel)!.progreddbarLottie)
        self.lottieImageView.play()
        let fullText = "사자력 Lv." + String(BadgeLevel(rawValue: input.daddyLevel)!.badgeLevel)
        let attributtedString = NSMutableAttributedString(string: fullText)
        attributtedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.designSystem(.white)!, range: (fullText as NSString).range(of: "Lv." + String(BadgeLevel(rawValue: input.daddyLevel)!.badgeLevel)))
        self.challengelevelLabel.attributedText = attributtedString
    }
    
    func setUIFromNetworking() {
        Task {
            do {
                self.showLoading()
                self.inputData = try await manager.inquireChallengeInfo()
                self.challengeDayCheckCollectionView.reloadData()
                self.hideLoading()
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}

private extension ChallengeViewController {
    
    enum Size {
        static let cellOffset: CGFloat = 40
        static let numberOfCellsinRow: CGFloat = 0
    }
    
    func setUI() {
        view.backgroundColor = .designSystem(.background)
        ChallengeDayCheckCollectionViewCollectionViewCell.register(to: challengeDayCheckCollectionView)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, nicknameLabel, leftSeperateLine, rightSeperateLine, levelBadge, challengeDayLabel, lottieImageView, challengeDayCheckCollectionView)
        levelBadge.addSubview(challengelevelLabel)
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        challengeDayLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        leftSeperateLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(15)
            make.trailing.equalTo(challengeDayLabel.snp.leading).offset(-8)
            make.height.equalTo(1)
            make.width.equalTo(36)
        }
        rightSeperateLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(15)
            make.leading.equalTo(challengeDayLabel.snp.trailing).offset(8)
            make.height.equalTo(1)
            make.width.equalTo(36)
        }
        levelBadge.snp.makeConstraints { make in
            make.top.equalTo(challengeDayLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        challengelevelLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        lottieImageView.snp.makeConstraints { make in
            make.top.equalTo(levelBadge.snp.bottom).offset(24)
            make.leading.equalTo(challengeDayCheckCollectionView.snp.leading)
            make.trailing.equalTo(challengeDayCheckCollectionView.snp.trailing)
            make.height.equalTo(24)
        }
        challengeDayCheckCollectionView.snp.makeConstraints { make in
            make.top.equalTo(lottieImageView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(ScreenUtils.getHeight(300))
        }
    }
    
    func setDelegate() {
        challengeDayCheckCollectionView.delegate = self
        challengeDayCheckCollectionView.dataSource = self
    }
    
    func setNavigation() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setAddTarget() {
        navigationBar.rightFirstBarItemAction {
            self.coordinator?.navigationLeftButtonTapped()
        }
        
        navigationBar.rightSecondBarItemAction {
            self.coordinator?.navigationRightButtonTapped()
        }
    }
}

extension ChallengeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 5
        let height = collectionView.frame.height / 5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ChallengeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ChallengeDayCheckCollectionViewCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
        guard let inputData else { return cell }
        if indexPath.item < inputData.daddyAttendances.count {
            cell.inputString = inputData.daddyAttendances[indexPath.item]
            cell.backgroundColor = .designSystem(.background)
            cell.whiteTextColor = .designSystem(.white)
        } else {
            cell.inputString = "\(indexPath.section + indexPath.row + 1)"
            cell.backgroundColor = .designSystem(.gray1000)
        }
        return cell
    }
}

extension ChallengeViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .urlEncodingError:
            LHToast.show(message: "url인코딩에러")
        case .jsonDecodingError:
            LHToast.show(message: "챌린지Decode에러")
        case .badCasting:
            LHToast.show(message: "배드캐스팅")
        case .fetchImageError:
            LHToast.show(message: "챌린지 이미지 패치 에러")
        case .unAuthorizedError:
            LHToast.show(message: "챌린지 Auth 에러")
        case .clientError(_, let message):
            LHToast.show(message: message)
        case .serverError:
            LHToast.show(message: error.description)
        }
    }
}
