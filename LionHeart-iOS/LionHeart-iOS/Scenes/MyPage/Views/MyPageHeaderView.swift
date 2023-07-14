//
//  MyPageHeaderView.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/14.
//

import UIKit

import SnapKit

final class MyPageHeaderView: UICollectionReusableView, CollectionSectionViewRegisterDequeueProtocol {
    
    private let sectionTitleLabel = {
        let label = UILabel()
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray500)
        return label
    }()
    
    var inputData: MyPageData? {
        didSet {
            configureData(inputData)
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
        backgroundColor = .clear
    }
    func setHierarchy() {
        addSubview(sectionTitleLabel)
    }
    
    func setLayout() {
        sectionTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
        }
    }
    
    func configureData(_ model: MyPageData?) {
        guard let model = model else { return }
        sectionTitleLabel.text = model.titleLabel
    }
}
