//
//  CompleteOnbardingViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//  Copyright (c) 2023 CompleteOnbarding. All rights reserved.
//

import UIKit

import SnapKit

final class CompleteOnbardingViewController: UIViewController {
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "사랑이아빠님\n반가워요"
        label.textColor = .designSystem(.white)
        label.font = .pretendard(.head2)
        return label
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

    }
}

private extension CompleteOnbardingViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubview(testLabel)
    }
    
    func setLayout() {
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
}
