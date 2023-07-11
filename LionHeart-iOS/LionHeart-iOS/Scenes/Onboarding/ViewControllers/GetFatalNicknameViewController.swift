//
//  GetFatalNicknameViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//  Copyright (c) 2023 GetFatalNickname. All rights reserved.
//

import UIKit

import SnapKit

final class GetFatalNicknameViewController: UIViewController {
    
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
        
        setTextField()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.fatalNickNameTextfield.becomeFirstResponder()
        }
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
            make.top.equalToSuperview().inset(36)
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
            make.top.equalTo(fatalNickNameTextfield.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(2)
        }
        
        fatalNickNameErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(fatalNickNameTextfield.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
    }
    
    func setTextField() {
        if let clearButton = fatalNickNameTextfield.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(named: Constant.ImageName.textFieldClear.real), for: .normal)
        }
        self.fatalNickNameTextfield.clearButtonMode = UITextField.ViewMode.whileEditing
    }
    

}
