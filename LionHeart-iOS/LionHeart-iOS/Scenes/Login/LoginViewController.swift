//
//  LoginViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Login. All rights reserved.
//

import UIKit
import SnapKit
import Combine


final class LoginViewController: UIViewController {
//    var userData: UserOnboardingModel?
    
    //    var navigator: LoginNavigation
    //
    //    private let manager: LoginManager
    
//    private var kakaoAccessToken: String? {
//        didSet {
//            guard let kakaoToken = self.kakaoAccessToken else {
//                LHToast.show(message: "카카오토큰 언래핑 실패 21")
//                return
//            }
//            self.loginAPI(kakaoToken: kakaoToken)
//        }
//    }
    
    // MARK: - Properties
    
    // Protocol with associatedtype : 우리가 아는 프로토콜 타입이 아님.
    // Protocol without associatedtype : 우리가 아는 프로토콜
    
    private let kakakoLoginButtonTap = PassthroughSubject<Void, Never>()
    
    private let viewModel: any LoginViewModel
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - UI Components

    private let loginMainImageView = LHImageView(in: ImageLiterals.Login.loginBackgroundImage, contentMode: .scaleAspectFill)

    private let mainLogoImageView = LHImageView(in: UIImage(named: "temporary_splash_image"), contentMode: .scaleAspectFit)

    private let mainLabel = LHLabel(type: .title2, color: .gray400, basicText: "하루 10분, 좋은 아빠가 되는 방법")

    private let kakakoLoginButton = LHImageButton(setImage: ImageLiterals.Login.kakaoLogo)
        .setTitle(font: .subHead2, text: "카카오로 로그인하기", color: .black)
        .setCornerRadius(for: 4)
        .setMarginImageWithText(for: 8)
        .setBackgroundColor(color: .kakao)

    // MARK: - LifeCycle
    /*
     some이나 any가 없다면...
     init에 어떤 객체를 넣어주게 될텐데, 그 객체의 upper bound는 컴파일러 입장에서는 알수가 없다.
     즉, LoginViewModel & LoginUseCase 프로토콜들을 채택하고 있는 객체인지 보장할 수가 없다는 뜻이다.
     
     some이나 any를 써주게 된다면
     */
    
    // some이나 any를 associatedtype이 있는 protocol
    init(viewModel: some LoginViewModel & LoginUseCase) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setHierarchy()
        setLayout()
//        setAddTarget()
        bindInput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func bind() {
        let input = LoginViewModelInput(
            kakakoLoginButtonTap: kakakoLoginButtonTap)
        let output = viewModel.transform(input: input)
        
        //TODO: - Output binding
        output.loginSuccess
            .sink { str in
                print(str)
            }
            .store(in: &cancelBag)
        
    }
    
    private func bindInput() {
        kakakoLoginButton.tapPublisher
            .sink { [weak self] _ in
                self?.kakakoLoginButtonTap.send(())
            }
            .store(in: &cancelBag)
    }
    
}



private extension LoginViewController {
    
    func setHierarchy() {
        view.addSubviews(loginMainImageView, mainLogoImageView, mainLabel, kakakoLoginButton)
    }
    
    func setLayout() {
        loginMainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainLogoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.leading.trailing.equalToSuperview().inset(120)
            make.height.equalTo(70)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLogoImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        kakakoLoginButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60)
            make.leading.trailing.equalToSuperview().inset(29)
            make.height.equalTo(50)
        }
    }
    

}
