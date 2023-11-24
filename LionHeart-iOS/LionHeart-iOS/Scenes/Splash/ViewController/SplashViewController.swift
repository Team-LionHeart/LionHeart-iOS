//
//  SplashViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Splash. All rights reserved.
//

import UIKit
import Combine

import SnapKit

protocol SplashViewControllerable where Self: UIViewController {}

final class SplashViewController: UIViewController, SplashViewControllerable {
    
    private let lottiePlayFinished = PassthroughSubject<Void, Never>()

    private let viewModel: any SplashViewModel
    
    private var cancelBag = Set<AnyCancellable>()
    
    private let lottieImageView = LHLottie(name: "motion_logo_final")

    init(viewModel: some SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        lottieImageView.play { [weak self] _ in
            self?.lottiePlayFinished.send(())
        }
    }
    
    private func bind() {
        let input = SplashViewModelInput(lottiePlayFinished: lottiePlayFinished)
        let output = viewModel.transform(input: input)
        output.splashNetworkErrorMessage
            .sink { errorMessage in
                print(errorMessage)
            }
            .store(in: &cancelBag)
    }
}

private extension SplashViewController {

    func setUI() {
        view.backgroundColor = .designSystem(.black)
    }
    
    func setHierarchy() {
        view.addSubviews(lottieImageView)
    }
    
    func setLayout() {
        lottieImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.centerX.equalToSuperview()
            make.size.equalTo(220)
        }
    }
}
