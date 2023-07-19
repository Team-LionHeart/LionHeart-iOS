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
    case level01 = "1"
    case level02 = "2"
    case level03 = "3"
    case level04 = "4"
    case level05 = "5"
    
    var levelBadge: UIImage {
        switch self {
        case .level01: return ImageLiterals.ChallengeBadge.level01
        case .level02: return ImageLiterals.ChallengeBadge.level02
        case .level03: return ImageLiterals.ChallengeBadge.level03
        case .level04: return ImageLiterals.ChallengeBadge.level04
        case .level05: return ImageLiterals.ChallengeBadge.level05
        }
    }
}

final class ChallengeViewController: UIViewController {
    
    var inputData: ChallengeData? {
        didSet {
            
            self.nicknameLabel.text = inputData?.babyDaddyName
            
            if let howLongDay = inputData?.howLongDay {
                            self.challengeDayLabel.text = "\(howLongDay)째 도전 중"
                        }
            
            self.challengelevelLabel.text = inputData?.daddyLevel
            
            self.levelBadge.image = BadgeLevel(rawValue: inputData?.daddyLevel ?? "1")?.levelBadge
            
            self.lottieImageView = LottieAnimationView(name: "Level\(inputData?.daddyLevel ?? "")")
            self.lottieImageView.play()
            let attributtedString = NSMutableAttributedString(string: self.challengelevelLabel.text ?? "")
            attributtedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.designSystem(.white) ?? .white, range: (self.challengelevelLabel.text! as NSString).range(of:"Lv.\(inputData?.daddyLevel ?? "")"))
            self.challengelevelLabel.attributedText = attributtedString
        }
    }
    
    private enum Size {
        static let cellOffset: CGFloat = 40
        static let numberOfCellsinRow: CGFloat = 0
        static let blockWidth: CGFloat = 67
        static let blockHeight: CGFloat = 60
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
        let view = LottieAnimationView(name: "Level\(inputData?.daddyLevel ?? "")")
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let challengeDayCheckCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .designSystem(.gray1000)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            do{
                let model = try await ChallengeService.shared.inquireChallengeInfo()
                self.inputData = model
            } catch {
                 print(error)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        leftSeperateLine.setGradient(firstColor: .designSystem(.gray800)!, secondColor: .designSystem(.gray400)!)
        rightSeperateLine.setGradient(firstColor: .designSystem(.gray400)!, secondColor: .designSystem(.gray800)!)
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
            make.bottom.equalToSuperview().inset(143)
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
}

extension ChallengeViewController:
    UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 5
        let height = collectionView.frame.height / 5
        return CGSize(width: width, height: height)
    }
}

extension ChallengeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ChallengeDayCheckCollectionViewCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
        cell.backgroundColor = .designSystem(.gray1000)
        cell.inputString = "\(indexPath.section + indexPath.row + 1)"
        return cell
    }
}
