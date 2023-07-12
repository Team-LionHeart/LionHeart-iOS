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
}

protocol PregnancyCheckDelegate: AnyObject {
    func checkPregnancy(resultType: OnboardingPregnancyTextFieldResultType)
}

final class GetPregnancyViewController: UIViewController {
    
    weak var delegate: PregnancyCheckDelegate?
    
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
    
    let pregnancyTextfield = OnboardingTextfield(textFieldType: .pregancy)
    
    private let fixedWeedLabel: UILabel = {
        let label = UILabel()
        label.text = "주차"
        label.font = .pretendard(.body1)
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - autolayout설정
        setLayout()
        
        // MARK: - button의 addtarget설정
        setAddTarget()
        
        // MARK: - delegate설정
        setDelegate()
        pregnancyTextfield.textAlignment = .right
        pregnancyTextfield.keyboardType = .numberPad
        

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
        view.addSubviews(titleLabel, descriptionLabel, pregnancyTextFieldStackView)
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(36)
            make.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        pregnancyTextFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.height.equalTo(72)
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        pregnancyTextfield.delegate = self
    }
 
}

extension GetPregnancyViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count == 0 || Int(text) == 0 {
            delegate?.checkPregnancy(resultType: .pregnancyTextFieldEmpty)
        } else if 1 <= (Int(text) ?? 0) && (Int(text) ?? 0) <= 40 {
            delegate?.checkPregnancy(resultType: .pregnancyTextFieldValid)
        } else {
            delegate?.checkPregnancy(resultType: .pregnancyTextFieldOver)
        }
    }
}
