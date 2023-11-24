//
//  MyPageTableSectionHeaderView.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/20.
//

import UIKit

import SnapKit

final class MyPageTableSectionHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "MyPageTableSectionHeaderView"
    
    private let sectionTitleLabel = LHLabel(type: .body3R, color: .gray500)
    
    var inputData: String? {
        didSet {
            sectionTitleLabel.text = inputData
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension MyPageTableSectionHeaderView {
    
    func setUI() {
        backgroundColor = .designSystem(.background)
    }
    func setHierarchy() {
        addSubview(sectionTitleLabel)
    }
    
    func setLayout() {
        sectionTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
