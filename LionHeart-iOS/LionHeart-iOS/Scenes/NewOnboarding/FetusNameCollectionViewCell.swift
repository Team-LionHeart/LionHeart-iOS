//
//  FetusNameCollectionViewCell.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/12.
//  Copyright (c) 2023 FetusName. All rights reserved.
//

import UIKit

import SnapKit

final class FetusNameCollectionViewCell: UICollectionViewCell, CollectionViewCellRegisterDequeueProtocol {
    
    var inputData: DummyModel? {
        didSet {
            /// action
        }
    }
    
    var isFocusted: Bool = false {
        didSet {
            if isFocusted {
                self.fatalNickNameTextfield.becomeFirstResponder()
            } else {
                self.fatalNickNameTextfield.resignFirstResponder()
            }
        }
    }
    
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
    
    let fatalNickNameTextfield = OnboardingTextfield(textFieldType: .fatalNickname)

    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension FetusNameCollectionViewCell {
    func setUI() {
        backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        addSubviews(titleLabel, descriptionLabel, fatalNickNameTextfield, textFieldUnderLine, fatalNickNameErrorLabel)
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
