//
//  MyPageHeaderView.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/14.
//

import UIKit

import SnapKit

final class MyPageHeaderView: UICollectionReusableView, CollectionSectionViewRegisterDequeueProtocol {
    
    private let sectionTitleLabel = LHLabel(type: .body3R, color: .gray500)
    
    var inputData: String? {
        didSet {
            sectionTitleLabel.text = inputData
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension MyPageHeaderView {
    
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
