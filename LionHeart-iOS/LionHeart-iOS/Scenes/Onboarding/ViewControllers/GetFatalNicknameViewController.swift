//
//  GetFatalNicknameViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//  Copyright (c) 2023 GetFatalNickname. All rights reserved.
//

import UIKit

import SnapKit

enum OnboardingFatalNicknameTextFieldResultType {
    case fatalNicknameTextFieldEmpty
    case fatalNicknameTextFieldOver
    case fatalNicknameTextFieldValid

    var errorMessage: String {
        switch self {
        case .fatalNicknameTextFieldEmpty:
            return "입력된 내용이 없습니다."
        case .fatalNicknameTextFieldOver:
            return "10자 이내로 입력해주세요."
        case .fatalNicknameTextFieldValid:
            return "정상입니다"
        }
    }
    
    var isHidden: Bool {
        switch self {
        case .fatalNicknameTextFieldEmpty, .fatalNicknameTextFieldOver:
            return true
        case .fatalNicknameTextFieldValid:
            return false
        }
    }
}

protocol FatalNicknameCheckDelegate: AnyObject {
    func checkFatalNickname(resultType: OnboardingFatalNicknameTextFieldResultType)
    func sendFatalNickname(nickName: String)
}

final class GetFatalNicknameViewController: UIViewController {
    
    weak var delegate: FatalNicknameCheckDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "태명을 정하셨나요?"
        label.font = .pretendard(.head2)
        label.textColor = .designSystem(.white)
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "아직이라면, 닉네임을 적어주세요."
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray400)
        return label
    }()
    
    private let textFieldUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.lionRed)
        return view
    }()
    
    private let fatalNickNameErrorLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.componentLionRed)
        return label
    }()
    
    private let fatalNickNameTextfield = OnboardingTextfield(textFieldType: .fatalNickname)
    

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
            delegate?.checkFatalNickname(resultType: .fatalNicknameTextFieldEmpty)
            fatalNickNameErrorLabel.text = OnboardingFatalNicknameTextFieldResultType.fatalNicknameTextFieldEmpty.errorMessage
            fatalNickNameErrorLabel.isHidden = false
        } else if text.count <= 10 {
            delegate?.checkFatalNickname(resultType: .fatalNicknameTextFieldValid)
            fatalNickNameErrorLabel.isHidden = true
        } else {
            delegate?.checkFatalNickname(resultType: .fatalNicknameTextFieldOver)
            fatalNickNameErrorLabel.text = OnboardingFatalNicknameTextFieldResultType.fatalNicknameTextFieldOver.errorMessage
            fatalNickNameErrorLabel.isHidden = false
        }
        delegate?.sendFatalNickname(nickName: text)
    }
}
