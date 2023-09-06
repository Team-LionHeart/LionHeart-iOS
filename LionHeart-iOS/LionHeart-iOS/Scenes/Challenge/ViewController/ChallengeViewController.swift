//
//  ChallengeViewController.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/13.
//  Copyright (c) 2023 Challenge. All rights reserved.
//

import UIKit

import SnapKit
import Lottie

enum BadgeLevel: String {
    case level01 = "LEVEL_ONE"
    case level02 = "LEVEL_TWO"
    case level03 = "LEVEL_THREE"
    case level04 = "LEVEL_FOUR"
    case level05 = "LEVEL_FIVE"
    
    var badgeLevel: Int {
        switch self {
        case .level01: return 1
        case .level02: return 2
        case .level03: return 3
        case .level04: return 4
        case .level05: return 5
        }
    }
    
    var badgeImage: UIImage {
        switch self {
        case .level01: return ImageLiterals.ChallengeBadge.level01
        case .level02: return ImageLiterals.ChallengeBadge.level02
        case .level03: return ImageLiterals.ChallengeBadge.level03
        case .level04: return ImageLiterals.ChallengeBadge.level04
        case .level05: return ImageLiterals.ChallengeBadge.level05
        }
    }
    
    var progreddbarLottie: String {
        switch self {
        case .level01: return "Level1"
        case .level02: return "Level2"
        case .level03: return "Level3"
        case .level04: return "Level4"
        case .level05: return "Level5"
        }
    }
}

final class ChallengeViewController: UIViewController {
    
    var inputData: ChallengeData? {
        didSet {
            guard let babyNickname = inputData?.babyDaddyName else { return }
            self.nicknameLabel.text = "\(babyNickname)아빠 님,"
            
            if let howLongDay = inputData?.howLongDay {
                self.challengeDayLabel.text = "\(howLongDay)일째 도전 중"
            }
    
            self.levelBadge.image = BadgeLevel(rawValue: inputData?.daddyLevel ?? "")?.badgeImage
            
            self.lottieImageView.animation = .named(BadgeLevel(rawValue: inputData?.daddyLevel ?? "")?.progreddbarLottie ?? "")
            self.lottieImageView.play()
            
            let fullText = "사자력 Lv." + String(BadgeLevel(rawValue: inputData?.daddyLevel ?? "")?.badgeLevel ?? 1)
            
            let attributtedString = NSMutableAttributedString(string: fullText)
            attributtedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.designSystem(.white) ?? .white, range: (fullText as NSString).range(of: "Lv." + String(BadgeLevel(rawValue: inputData?.daddyLevel ?? "")?.badgeLevel ?? 1)))
            
            self.challengelevelLabel.attributedText = attributtedString
        }
    }
    
    private enum Size {
        static let cellOffset: CGFloat = 40
        static let numberOfCellsinRow: CGFloat = 0
    }
    
    private let leftSeperateLine: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.background)
        return view
    }()
    
    private let rightSeperateLine: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.background)
        return view
    }()
    
    private var tags: [String] = []
    
    private lazy var navigationBar = LHNavigationBarView(type: .challenge, viewController: self)
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.gray200)
        label.textAlignment = .center
        return label
    }()
    
    private let challengeDayLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head3)
        label.textColor = .designSystem(.white)
        label.textAlignment = .center
        return label
    }()
    
    private let levelBadge: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.ChallengeBadge.level05
        return imageView
        }()

    private let challengelevelLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.gray500)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var lottieImageView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let challengeDayCheckCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .designSystem(.background)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            do {
                self.showLoading()
                let model = try await ChallengeService.shared.inquireChallengeInfo()
                self.inputData = model
                self.tags = model.daddyAttendances
                self.challengeDayCheckCollectionView.reloadData()
                self.hideLoading()
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
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
    func setUI() {
        view.backgroundColor = .designSystem(.background)
        ChallengeDayCheckCollectionViewCollectionViewCell.register(to: challengeDayCheckCollectionView)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         nicknameLabel, leftSeperateLine, rightSeperateLine, levelBadge, challengeDayLabel, lottieImageView, challengeDayCheckCollectionView)
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
            let bookmarkViewController = BookmarkViewController()
            self.navigationController?.pushViewController(bookmarkViewController, animated: true)
        }
        
        navigationBar.rightSecondBarItemAction {
            let wrapper = AuthMyPageServiceWrapper(myPageService: MyPageService(), authService: AuthService())
            let myPageViewController = MyPageViewController(service: wrapper)
            self.navigationController?.pushViewController(myPageViewController, animated: true)
        }
    }
}

extension ChallengeViewController:
    UICollectionViewDelegateFlowLayout {
    
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
        
        if indexPath.item < tags.count {
            cell.inputString = tags[indexPath.item]
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
            LHToast.show(message: "서버문제!")
        }
    }
}
