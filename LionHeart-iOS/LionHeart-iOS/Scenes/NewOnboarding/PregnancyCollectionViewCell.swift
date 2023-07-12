//
//  PregnancyCollectionViewCell.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/12.
//  Copyright (c) 2023 Pregnancy. All rights reserved.
//

import UIKit

import SnapKit

final class PregnancyCollectionViewCell: UICollectionViewCell, CollectionViewCellRegisterDequeueProtocol {
    
    var inputData: DummyModel? {
        didSet {
            /// action
        }
    }
    
    var isFocusted: Bool = false {
        didSet {
            if isFocusted {
                self.pregnancyTextfield.becomeFirstResponder()
            } else {
                self.pregnancyTextfield.resignFirstResponder()
            }
        }
    }
    
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
        pregnancyTextfield.textAlignment = .right
        pregnancyTextfield.keyboardType = .numberPad
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}

private extension PregnancyCollectionViewCell {
    
    func setUI() {
        backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        addSubviews(titleLabel, descriptionLabel, pregnancyTextFieldStackView)
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
    }
}
