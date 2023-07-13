//
//  GetFatalNicknameViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//  Copyright (c) 2023 GetFatalNickname. All rights reserved.
//

import UIKit

import SnapKit

protocol FatalNicknameCheckDelegate: AnyObject {
    func checkFatalNickname(resultType: OnboardingFatalNicknameTextFieldResultType)
    func sendFatalNickname(nickName: String)
}

final class GetFatalNicknameViewController: UIViewController {
    
    weak var delegate: FatalNicknameCheckDelegate?
    private let titleLabel = LHOnboardingTitle("태명을 정하셨나요?")
    private let descriptionLabel = LHOnboardingDescription("아직이라면, 닉네임을 적어주세요.")
    private let fatalNickNameErrorLabel = LHOnboardingError()
    private let fatalNickNameTextfield = NHOnboardingTextfield(textFieldType: .fatalNickname)
    private let textFieldUnderLine = NHUnderLine(lineColor: .designSystem(.lionRed))
    

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fatalNickNameTextfield.becomeFirstResponder()
    }
}

private extension GetFatalNicknameViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(titleLabel, descriptionLabel, fatalNickNameTextfield, textFieldUnderLine, fatalNickNameErrorLabel)
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
        
        fatalNickNameTextfield.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(68)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }
        
        textFieldUnderLine.snp.makeConstraints { make in
            make.top.equalTo(fatalNickNameTextfield.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1.5)
        }
        
        fatalNickNameErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(fatalNickNameTextfield.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    func setTextField() {
        fatalNickNameTextfield.delegate = self
        if let clearButton = fatalNickNameTextfield.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(named: Constant.ImageName.textFieldClear.real), for: .normal)
        }
        self.fatalNickNameTextfield.clearButtonMode = UITextField.ViewMode.whileEditing
    }
}

extension GetFatalNicknameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count == 0 {
            textFieldSettingWhenEmpty()
        } else if text.count <= 10 {
            textFieldSettingWhenValid()
        } else {
            textFieldSettingWhenOver()
        }
        delegate?.sendFatalNickname(nickName: text)
    }
}

private extension GetFatalNicknameViewController {
    func textFieldSettingWhenEmpty() {
        delegate?.checkFatalNickname(resultType: .fatalNicknameTextFieldEmpty)
        fatalNickNameErrorLabel.text = OnboardingFatalNicknameTextFieldResultType.fatalNicknameTextFieldEmpty.errorMessage
        fatalNickNameErrorLabel.isHidden = false
    }
    
    func textFieldSettingWhenValid() {
        delegate?.checkFatalNickname(resultType: .fatalNicknameTextFieldValid)
        fatalNickNameErrorLabel.isHidden = true
    }
    
    func textFieldSettingWhenOver() {
        delegate?.checkFatalNickname(resultType: .fatalNicknameTextFieldOver)
        fatalNickNameErrorLabel.text = OnboardingFatalNicknameTextFieldResultType.fatalNicknameTextFieldOver.errorMessage
        fatalNickNameErrorLabel.isHidden = false
    }
}
