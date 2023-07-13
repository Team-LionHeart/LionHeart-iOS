//
//  GetPregnancyViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//  Copyright (c) 2023 GetPregnancy. All rights reserved.
//

import UIKit

import SnapKit

protocol PregnancyCheckDelegate: AnyObject {
    func checkPregnancy(resultType: OnboardingPregnancyTextFieldResultType)
    func sendPregnancyContent(pregnancy: Int)
}

final class GetPregnancyViewController: UIViewController {
    
    weak var delegate: PregnancyCheckDelegate?
    private let titleLabel = LHOnboardingTitleLabel("현재 임신 주수를\n알려주세요")
    private let descriptionLabel = LHOnboardingDescriptionLabel("시기별 맞춤 아티클을 전해드려요")
    private let pregnancyTextfield = NHOnboardingTextfield(textFieldType: .pregancy)
    private let fixedWeekLabel = LHOnboardingTitleLabel("주차")
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
    
}

extension GetPregnancyViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        /// textField의 text의 갯수에 따른 로직
        textField.placeholder = text.count == 0 ? "1~40" : ""
        if text.count == 0 {
            textFieldSettingWhenEmpty()
        }
        
        /// textField의 text의 숫자에 따른 로직
        guard let textNumber = Int(text) else { return }
        if textNumber == 0 {
            textFieldSettingWhenInputNumberZero()
        } else if 1 <= textNumber && textNumber <= 40 {
            textFieldSettingWhenInputNumberValid()
        } else {
            textFieldSettingWhenInpubNumberOver()
        }
        
        /// 현재 textField에 text를 PageViewController로 보내주는 delegate
        delegate?.sendPregnancyContent(pregnancy: textNumber)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 { return true }
        }
        guard let text = textField.text else { return false }
        return text.count >= 2 ? false : true
    }

}

extension GetPregnancyViewController {
    func textFieldSettingWhenEmpty() {
        delegate?.checkPregnancy(resultType: .pregnancyTextFieldEmpty)
        pregnancyErrorLabel.text = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldEmpty.errorMessage
    }
    
    func textFieldSettingWhenInputNumberZero() {
        delegate?.checkPregnancy(resultType: .pregnancyTextFieldEmpty)
        pregnancyErrorLabel.text = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldOver.errorMessage
    }
    
    func textFieldSettingWhenInputNumberValid() {
        delegate?.checkPregnancy(resultType: .pregnancyTextFieldValid)
        pregnancyErrorLabel.text = ""
    }
    
    func textFieldSettingWhenInpubNumberOver() {
        delegate?.checkPregnancy(resultType: .pregnancyTextFieldOver)
        pregnancyErrorLabel.text = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldOver.errorMessage
    }
}
