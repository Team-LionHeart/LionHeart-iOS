//
//  ChallengeViewController.swift
//  LionHeart-iOS
//
//  Created by 김의성 on 2023/09/24.
//  Copyright (c) 2023 Challenge. All rights reserved.
//

import UIKit
import Combine

import SnapKit
import Lottie

protocol ChallengeViewControllerable where Self: UIViewController {}

final class ChallengeViewController: UIViewController, ChallengeViewControllerable {
    private let navigationLeftButtonTapped = PassthroughSubject<Void, Never>()
    private let navigationRightButtonTapped = PassthroughSubject<Void, Never>()
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    private let viewModel: any ChallengeViewModel
    
    private let leftSeperateLine = LHUnderLine(lineColor: .background)
    private let rightSeperateLine = LHUnderLine(lineColor: .background)
    lazy var navigationBar = LHNavigationBarView(type: .challenge, viewController: self)
    let nicknameLabel = LHLabel(type: .body2R, color: .gray200)
    let challengeDayLabel = LHLabel(type: .head3, color: .white)
    let challengelevelLabel = LHLabel(type: .body4, color: .gray500)
    let levelBadge = LHImageView(in: ImageLiterals.ChallengeBadge.level05, contentMode: .scaleToFill)
    private lazy var lottieImageView = LHLottie()
    let challengeDayCheckCollectionView = LHCollectionView()
    private var diffableDataSource: UICollectionViewDiffableDataSource<ChallengeSection, Int>!
    
    init(viewModel: some ChallengeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading()
        self.viewWillAppearSubject.send(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setNavigationBar()
        setDelegate()
        bindInput()
        bind()
    }
    
    private func bindInput() {
        navigationBar.rightFirstBarItem.tapPublisher
            .sink { [weak self] in self?.navigationLeftButtonTapped.send($0) }
            .store(in: &cancelBag)
        navigationBar.rightSecondBarItem.tapPublisher
            .sink { [weak self] in self?.navigationRightButtonTapped.send($0) }
            .store(in: &cancelBag)
    }
    
    private func bind() {
        let input = ChallengeViewModelInput(navigationLeftButtonTapped: navigationLeftButtonTapped, navigationRightButtonTapped: navigationRightButtonTapped, viewWillAppearSubject: viewWillAppearSubject)
        let output = viewModel.transform(input: input)
        output.viewWillAppearSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.configureData(data)
                self?.hideLoading()
            }
            .store(in: &cancelBag)
    }
}

extension ChallengeViewController {
    func configureData(_ input: ChallengeData) {
        setText(by: input)
        setImage(by: input)
        setDataSource(by: input)
        updateSections()
    }
    
    func setDataSource(by input: ChallengeData) {
        diffableDataSource = .init(collectionView: challengeDayCheckCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = ChallengeDayCheckCollectionViewCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
            cell.configure(type: indexPath.item < input.daddyAttendances.count ? .read : .yet, input: input, indexPath: indexPath)
            return cell
        })
    }
    
    func setText(by input: ChallengeData) {
        self.nicknameLabel.text = "\(input.babyDaddyName)아빠 님,"
        self.challengeDayLabel.text = "\(input.howLongDay)일째 도전 중"
        let levelText = String(BadgeLevel(rawValue: input.daddyLevel)!.badgeLevel)
        let fullText = "사자력 Lv." + levelText
        let attributtedString = NSMutableAttributedString(string: fullText)
        self.challengelevelLabel.attributedText = attributtedString
    }
    
    func setImage(by input: ChallengeData) {
        self.levelBadge.image = BadgeLevel(rawValue: input.daddyLevel)!.badgeImage
        self.lottieImageView.animation = .named(BadgeLevel(rawValue: input.daddyLevel)!.progreddbarLottie)
        self.lottieImageView.play()
    }
    
    func updateSections() {
        var snapshot = NSDiffableDataSourceSnapshot<ChallengeSection, Int>()
        snapshot.appendSections([.calendar])
        snapshot.appendItems([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20])
        self.diffableDataSource.apply(snapshot)
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
    }
    
    func setNavigation() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
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
