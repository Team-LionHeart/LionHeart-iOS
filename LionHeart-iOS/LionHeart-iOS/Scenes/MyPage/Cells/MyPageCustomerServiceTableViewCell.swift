//
//  MyPageCustomerServiceTableViewCell.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/20.
//

import UIKit

import SnapKit

final class MyPageCustomerServiceTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {
    
    private let listNameLabel = LHLabel(type: .body2M, color: .white)
    private lazy var nextButton = LHImageButton(setImage: ImageLiterals.Curriculum.arrowRightSmall)
    private let bottomView = LHView(color: .designSystem(.gray800))
    
    var inputData: String? {
        didSet {
            listNameLabel.text = inputData
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .designSystem(.background)
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyPageCustomerServiceTableViewCell {
    func setHierarchy() {
        addSubviews(listNameLabel, nextButton, bottomView)
    }
    
    func setLayout() {
        listNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func setAddTarget() {
        nextButton.addButtonAction { _ in
            print("눌리냐")
        }
    }
}
