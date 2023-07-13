//
//  GetFetalNicknameViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//  Copyright (c) 2023 GetFetalNickname. All rights reserved.
//

import UIKit

import SnapKit

protocol FetalNicknameCheckDelegate: AnyObject {
    func checkFetalNickname(resultType: OnboardingFetalNicknameTextFieldResultType)
    func sendFetalNickname(nickName: String)
}

final class GetFetalNicknameViewController: UIViewController {
    
    weak var delegate: FetalNicknameCheckDelegate?
    private let titleLabel = LHOnboardingTitleLabel("태명을 정하셨나요?")
    private let descriptionLabel = LHOnboardingDescriptionLabel("아직이라면, 닉네임을 적어주세요.")
    private let fetalNickNameErrorLabel = LHOnboardingErrorLabel()
    private let fetalNickNameTextfield = NHOnboardingTextfield(textFieldType: .fetalNickname)
    private let textFieldUnderLine = NHUnderLine(lineColor: .designSystem(.lionRed))
    

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetalNickNameTextfield.becomeFirstResponder()
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
        fetalNickNameTextfield.delegate = self
        if let clearButton = fetalNickNameTextfield.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(named: Constant.ImageName.textFieldClear.real), for: .normal)
        }
        self.fetalNickNameTextfield.clearButtonMode = UITextField.ViewMode.whileEditing
    }
}

extension GetFetalNicknameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count == 0 {
            textFieldSettingWhenEmpty()
        } else if text.count <= 10 {
            textFieldSettingWhenValid()
        } else {
            textFieldSettingWhenOver()
        }
        delegate?.sendFetalNickname(nickName: text)
    }
}

private extension GetFetalNicknameViewController {
    func textFieldSettingWhenEmpty() {
        delegate?.checkFetalNickname(resultType: .fetalNicknameTextFieldEmpty)
        fetalNickNameErrorLabel.text = OnboardingFetalNicknameTextFieldResultType.fetalNicknameTextFieldEmpty.errorMessage
        fetalNickNameErrorLabel.isHidden = false
    }
    
    func textFieldSettingWhenValid() {
        delegate?.checkFetalNickname(resultType: .fetalNicknameTextFieldValid)
        fetalNickNameErrorLabel.isHidden = true
    }
    
    func textFieldSettingWhenOver() {
        delegate?.checkFetalNickname(resultType: .fetalNicknameTextFieldOver)
        fetalNickNameErrorLabel.text = OnboardingFetalNicknameTextFieldResultType.fetalNicknameTextFieldOver.errorMessage
        fetalNickNameErrorLabel.isHidden = false
    }
}
