//
//  GetFetalNicknameViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//  Copyright (c) 2023 GetFetalNickname. All rights reserved.
//

import UIKit
import Combine

import SnapKit


final class GetFetalNicknameViewController: UIViewController {
    
    let fetalIsValid = PassthroughSubject<Bool, Never>()
    
    private let viewModel: any GetFetalNicknameViewModel
    
    private let fetalTextfieldDidChanged = PassthroughSubject<String, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    private let titleLabel = LHOnboardingTitleLabel("태명을 정하셨나요?", align: .left)
    private let descriptionLabel = LHOnboardingDescriptionLabel("아직이라면, 닉네임을 적어주세요.")
    private let fetalNickNameErrorLabel = LHOnboardingErrorLabel()
    private let fetalNickNameTextfield = NHOnboardingTextfield(textFieldType: .fetalNickname)
    private let textFieldUnderLine = LHUnderLine(lineColor: .lionRed)
    
    init(viewModel: some GetFetalNicknameViewModel) {
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
        setTextField()
        bindInput()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetalNickNameTextfield.becomeFirstResponder()
    }
    
    private func bindInput() {
        fetalNickNameTextfield.textPublisher
            .sink { [weak self] in
                self?.fetalTextfieldDidChanged.send($0)
            }
            .store(in: &cancelBag)
    }
    
    private func bind() {
        let input = GetFetalNicknameViewModelInput(fetalTextfieldDidChanged: fetalTextfieldDidChanged)
        let output = viewModel.transform(input: input)
        
        output.fetalTextfieldValidationMessage
            .sink { [weak self] in
                self?.fetalNickNameErrorLabel.text = $0.validationMessage
                self?.fetalIsValid.send($0.isHidden)
            }
            .store(in: &cancelBag)
        
    }
}

private extension GetFetalNicknameViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(titleLabel, descriptionLabel, fetalNickNameTextfield, textFieldUnderLine, fetalNickNameErrorLabel)
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        fetalNickNameTextfield.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(68)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }
        
        textFieldUnderLine.snp.makeConstraints { make in
            make.top.equalTo(fetalNickNameTextfield.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1.5)
        }
        
        fetalNickNameErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(fetalNickNameTextfield.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    func setTextField() {
        if let clearButton = fetalNickNameTextfield.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(.assetImage(.textFieldClear), for: .normal)
        }
        self.fetalNickNameTextfield.clearButtonMode = UITextField.ViewMode.whileEditing
    }
}
