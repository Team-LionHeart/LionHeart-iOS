//
//  NHOnboardingTextfield.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//

import UIKit

final class NHOnboardingTextfield: UITextField {
    
    enum TextFieldType {
        case pregancy
        case fetalNickname
        
        var placeHolder: String {
            switch self {
            case .pregancy:
                return "1~40"
            case .fetalNickname:
                return "태명"
            }
        }
    }
    
    private var textFieldType: TextFieldType
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(.assetImage(.textFieldClear), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    init(textFieldType: TextFieldType) {
        self.textFieldType = textFieldType
        super.init(frame: .zero)
        setUI()
        setButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .clear
        self.font = .pretendard(.head2)
        self.textColor = .designSystem(.white)
        clearButton.frame = .init(x: 0, y: 0, width: 28, height: 28)
        clearButton.contentMode = .scaleAspectFit
        self.setPlaceholder(placeholder: textFieldType.placeHolder, fontColor: .designSystem(.gray700), font: .pretendard(.head2))
        self.rightView = clearButton
        self.tintColor = .designSystem(.lionRed)
    }
    
    private func setButtonAction() {
        clearButton.addButtonAction { sender in
            self.text = ""
            sender.isHidden = true
        }
    }
}
