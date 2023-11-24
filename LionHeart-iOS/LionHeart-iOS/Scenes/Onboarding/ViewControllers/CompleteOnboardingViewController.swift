//
//  CompleteOnboardingViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//  Copyright (c) 2023 CompleteOnbarding. All rights reserved.
//

import UIKit
import Combine

import SnapKit

protocol CompleteOnboardingViewControllerable where Self: UIViewController { }

final class CompleteOnboardingViewController: UIViewController, CompleteOnboardingViewControllerable {
    
    private enum SizeInspector {
        static let sideOffset: CGFloat = 58
    }
    
    private var cancelBag = Set<AnyCancellable>()
    private let viewModel: any CompleteOnboardingViewModel
    private let startButtonTapped = PassthroughSubject<Void, Never>()
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    
    private let titleLabel = LHOnboardingTitleLabel(nil, align: .center)
    private let descriptionLabel = LHOnboardingDescriptionLabel("아티클 맞춤 환경이 준비되었어요.")
    private let startButton = LHRoundButton(cornerRadius: 8, title: "시작하기")
    
    /// 추후 삭제할 component
    private let welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.Onboarding.onboardingCompleteImage
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(viewModel: some CompleteOnboardingViewModel) {
        self.viewModel = viewModel
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
        bind()
        bindInput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewWillAppearSubject.send(())
    }
    
    private func bind() {
        let input = CompleteOnboardingViewModelInput(startButtonTapped: startButtonTapped,
                                                     viewWillAppear: viewWillAppearSubject)
        let output = viewModel.transform(input: input)
        
        output.fetalNickname
            .receive(on: RunLoop.main)
            .sink { [weak self] fetalNickname in
                guard let fetalNickname = fetalNickname else { return }
                self?.titleLabel.text = "\(fetalNickname)님\n반가워요!"
            }
            .store(in: &cancelBag)
    }
    
    private func bindInput() {
        startButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.startButtonTapped.send(())
            }
            .store(in: &cancelBag)
    }
}

private extension CompleteOnboardingViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(welcomeImageView, titleLabel, descriptionLabel, startButton)
    }
    
    func setLayout() {
        welcomeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(180)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.Screen.width - (2*SizeInspector.sideOffset))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeImageView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(50)
        }
    }
}
