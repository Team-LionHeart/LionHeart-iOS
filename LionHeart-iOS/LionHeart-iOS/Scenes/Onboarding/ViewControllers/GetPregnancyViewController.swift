//
//  GetPregnancyViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//  Copyright (c) 2023 GetPregnancy. All rights reserved.
//

import UIKit

import SnapKit

enum OnboardingPregnancyTextFieldResultType {
    case pregnancyTextFieldEmpty
    case pregnancyTextFieldValid
    case pregnancyTextFieldOver
    
    var errorMessage: String {
        switch self {
        case .pregnancyTextFieldEmpty:
            return "입력된 내용이 없습니다"
        case .pregnancyTextFieldValid:
            return "정상입니다"
        case .pregnancyTextFieldOver:
            return "1에서 40 사이의 숫자를 입력해주세요."
        }
    }
    
    var isHidden: Bool {
        switch self {
        case .pregnancyTextFieldEmpty, .pregnancyTextFieldOver:
            return true
        case .pregnancyTextFieldValid:
            return false
        }
    }
}

protocol PregnancyCheckDelegate: AnyObject {
    func checkPregnancy(resultType: OnboardingPregnancyTextFieldResultType)
    func sendPregnancyContent(pregnancy: Int)
}

final class GetPregnancyViewController: UIViewController {
    
    weak var delegate: PregnancyCheckDelegate?
    
    var textfieldTrailingInset: Constraint?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 임신 주수를\n알려주세요"
        label.font = .pretendard(.head2)
        label.textColor = .designSystem(.white)
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "시기별 맞춤 아티클을 전해드려요."
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray400)
        return label
    }()
    
    private let pregnancyTextfield = OnboardingTextfield(textFieldType: .pregancy)
    
    private let textBox: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let boundaryBox: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray900)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let fixedWeedLabel: UILabel = {
        let label = UILabel()
        label.text = "주차"
        label.font = .pretendard(.head2)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    private lazy var pregnancyTextFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pregnancyTextfield, fixedWeedLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private let pregnancyErrorLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.componentLionRed)
        return label
    }()
    
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
        view.addSubviews(titleLabel, descriptionLabel, textBox, boundaryBox, pregnancyErrorLabel)
        textBox.addSubviews(pregnancyTextfield, fixedWeedLabel)
        boundaryBox.addSubviews(textBox)
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
        
        textBox.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            textfieldTrailingInset = make.centerX.equalTo(boundaryBox.snp.centerX).offset(0).constraint
        }
        
        pregnancyTextfield.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(fixedWeedLabel.snp.leading).offset(-4)
        }
        
        fixedWeedLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(5)
        }
        
        boundaryBox.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(72)
        }
        
        pregnancyErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(boundaryBox.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(36)
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
        if text.count == 0 {
            delegate?.checkPregnancy(resultType: .pregnancyTextFieldEmpty)
            pregnancyErrorLabel.text = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldEmpty.errorMessage
            textfieldTrailingInset?.update(offset: 0)
        }
        guard let textNumber = Int(text) else { return }
        if textNumber == 0 {
            delegate?.checkPregnancy(resultType: .pregnancyTextFieldEmpty)
            pregnancyErrorLabel.text = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldOver.errorMessage
        } else if (1 <= textNumber) && (textNumber <= 40) {
            delegate?.checkPregnancy(resultType: .pregnancyTextFieldValid)
            pregnancyErrorLabel.text = ""
        } else {
            delegate?.checkPregnancy(resultType: .pregnancyTextFieldOver)
            pregnancyErrorLabel.text = OnboardingPregnancyTextFieldResultType.pregnancyTextFieldOver.errorMessage
        }
        
        if text.count == 1 {
            textfieldTrailingInset?.update(offset: -12)
        } else if text.count == 2 {
            textfieldTrailingInset?.update(offset: -6)
        }
        
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
