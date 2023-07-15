//
//  ChallengeViewController.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/13.
//  Copyright (c) 2023 Challenge. All rights reserved.
//

import UIKit

import SnapKit

final class ChallengeViewController: UIViewController {
    
    private enum Size {
        static let cellOffset: CGFloat = 40
        static let numberOfCellsinRow: CGFloat = 0
        static let blockWidth: CGFloat = 67
        static let blockHeight: CGFloat = 60
    }
    
    private lazy var navigationBar = LHNavigationBarView(type: .challenge, viewController: self)
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "동현이는슈퍼맨아빠님,"
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.gray200)
        label.textAlignment = .center
        return label
    }()
    
    private let challengeDayLabel: UILabel = {
        let label = UILabel()
        label.text = "23일째 도전 중"
        label.font = .pretendard(.head3)
        label.textColor = .designSystem(.white)
        label.textAlignment = .center
        return label
    }()
    
    private let levelBadge: UIImageView = {
        let imageView = UIImageView()
        //        imageView.image = .assetImage(.img_levelBadge)
        imageView.image = ImageLiterals.ChallengeBadge.level05
        return imageView
    }()
    
    private let challengelevelLabel: UILabel = {
        let label = UILabel()
        label.text = "사자력 Lv.5"
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.gray500)
        label.textAlignment = .center
        
        let attributtedString = NSMutableAttributedString(string: label.text!)
        attributtedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.designSystem(.white), range: (label.text! as NSString).range(of:"Lv.5"))
        label.attributedText = attributtedString
        return label
    }()
    
    private let leftLine: UIImageView = {
        let imageView = UIImageView()
        //        imageView.image = .assetImage(.leftline)
        return imageView
    }()
    
    private let rightLine: UIImageView = {
        let imageView = UIImageView()
        //        imageView.image = .assetImage(.rightLine)
        return imageView
    }()
    
    private let levelBar: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = ImageLiterals.ChallengeBar.exampleDonghyun
        return imageView
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        setHierarchy()
        setLayout()
        setNavigationBar()
        setDelegate()
    }
}

private extension ChallengeViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
        ChallengeDayCheckCollectionViewCollectionViewCell.register(to: challengeDayCheckCollectionView)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         nicknameLabel, challengeDayLabel, leftLine, rightLine, levelBadge, levelBar, challengeDayCheckCollectionView)
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
            make.bottom.equalTo(challengeDayLabel.snp.top)
            make.centerX.equalToSuperview()
        }
        challengeDayLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        leftLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            make.trailing.equalTo(challengeDayLabel.snp.leading).offset(-8)
        }
        rightLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            make.leading.equalTo(challengeDayLabel.snp.trailing).offset(8)
        }
        levelBadge.snp.makeConstraints { make in
            make.top.equalTo(challengeDayLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        challengelevelLabel.snp.makeConstraints { make in
            make.top.equalTo(levelBadge.snp.top).inset(16)
            make.centerX.equalToSuperview()
        }
        levelBar.snp.makeConstraints { make in
            make.top.equalTo(levelBadge.snp.bottom).offset(24)
//            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(335)
        }
        challengeDayCheckCollectionView.snp.makeConstraints { make in
            make.top.equalTo(levelBar.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(145)
        }
    }
    
    func setAddTarget() {
        
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
