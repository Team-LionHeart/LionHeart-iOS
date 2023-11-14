//
//  GetPregnancyViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//  Copyright (c) 2023 GetPregnancy. All rights reserved.
//

import UIKit
import Combine

import SnapKit


final class GetPregnancyViewController: UIViewController {
    
    private var cancelBag = Set<AnyCancellable>()
    var pregnancyIsValid = PassthroughSubject<Bool, Never>()
    private var pregancyTextfieldDidChanged = PassthroughSubject<String, Never>()
    private var viewModel: any GetPregnancyViewModel
    private let titleLabel = LHOnboardingTitleLabel("현재 임신 주수를\n알려주세요", align: .left)
    private let descriptionLabel = LHOnboardingDescriptionLabel("시기별 맞춤 아티클을 전해드려요")
    private let pregnancyTextfield = NHOnboardingTextfield(textFieldType: .pregancy)
    private let fixedWeekLabel = LHOnboardingTitleLabel("주차", align: .left)
    private var pregnancyErrorLabel = LHOnboardingErrorLabel()
    private let userInputContainerView = ContainerView()
    private let roundRectView = RoundContainerView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        setTextField()
        bindInput()
        bind()
    }
    
    init(viewModel: some GetPregnancyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pregnancyTextfield.becomeFirstResponder()
    }
}

private extension GetPregnancyViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        userInputContainerView.addSubviews(pregnancyTextfield, fixedWeekLabel)
        roundRectView.addSubviews(userInputContainerView)
        view.addSubviews(titleLabel, descriptionLabel, roundRectView, pregnancyErrorLabel)
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
        
        userInputContainerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(roundRectView.snp.centerX)
        }
        
        fixedWeekLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(5)
        }
        
        pregnancyTextfield.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(fixedWeekLabel.snp.leading).offset(-4)
        }
        
        roundRectView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(72)
        }
        
        pregnancyErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(roundRectView.snp.bottom).offset(8)
            make.leading.equalTo(roundRectView.snp.leading)
        }
    }
    
    func setDelegate() {
        pregnancyTextfield.delegate = self
    }
    
    func setTextField() {
        pregnancyTextfield.textAlignment = .right
        pregnancyTextfield.keyboardType = .numberPad
    }
    
    func bindInput() {
        pregnancyTextfield.textPublisher
            .sink { [weak self] in self?.pregancyTextfieldDidChanged.send($0) }
            .store(in: &cancelBag)
    }
    
    func bind() {
        let input = GetPregnancyViewModelInput(pregancyTextfieldDidChanged: pregancyTextfieldDidChanged)
        let output = viewModel.transform(input: input)
        output.pregancyTextfieldValidationMessage
            .sink { [weak self] in
                self?.pregnancyErrorLabel.text = $0.ValidationiMessage
                self?.pregnancyIsValid.send($0.isHidden)
            }
            .store(in: &cancelBag)
    }
}

extension GetPregnancyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 { return true }
        }
        guard let text = textField.text else { return false }
        return text.count >= 2 ? false : true
    }
}
