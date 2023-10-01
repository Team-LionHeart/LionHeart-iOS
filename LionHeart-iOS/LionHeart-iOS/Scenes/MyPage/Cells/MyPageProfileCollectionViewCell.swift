//
//  MyPageProfileCollectionViewCell.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/14.
//  Copyright (c) 2023 MyPageProfile. All rights reserved.
//

import UIKit

import SnapKit

final class MyPageProfileCollectionViewCell: UICollectionViewCell, CollectionViewCellRegisterDequeueProtocol {
    
    private enum Size {
        static let buttonMutipleSize: CGFloat = 40/320
    }
    
    private let badgeImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let profileLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .pretendard(.head3)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    private lazy var profileEditButton = {
        var titleAttr = AttributedString.init("정보 수정")
        titleAttr.font = .pretendard(.body3R)
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = titleAttr
        configuration.baseForegroundColor = .designSystem(.componentLionRed)
        configuration.baseBackgroundColor = .designSystem(.gray1000)
        configuration.imagePadding = 6
        configuration.image = ImageLiterals.MyPage.penColorIcon
        let button = UIButton(configuration: configuration)
        button.addButtonAction { [weak self] _ in
            print("눌림")
        }
        button.backgroundColor = .designSystem(.gray1000)
        button.layer.cornerRadius = 4
        return button
    }()
    
    var inputData: BadgeProfileAppData? {
        didSet {
            guard let inputData else { return }
            
            profileLabel.text = """
                                \(inputData.nickname)아빠님,
                                오늘도 멋진 아빠가 되어 볼까요?
                                """
            badgeImageView.image = BadgeLevel(rawValue: inputData.badgeImage)?.badgeImage
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setAddTarget()
        setDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyPageProfileCollectionViewCell {
    func setHierarchy() {
        addSubviews(badgeImageView, profileLabel, profileEditButton)
    }
    
    func setLayout() {
        badgeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(ScreenUtils.getWidth(64))
            $0.height.equalTo(badgeImageView.snp.width).multipliedBy(1)
        }
        
        profileLabel.snp.makeConstraints {
            $0.top.equalTo(badgeImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        profileEditButton.snp.makeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(profileEditButton.snp.width).multipliedBy(Size.buttonMutipleSize)
        }
   }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
}
