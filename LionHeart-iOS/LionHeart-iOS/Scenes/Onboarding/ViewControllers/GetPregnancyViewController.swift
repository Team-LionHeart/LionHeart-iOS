//
//  GetPregnancyViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/11.
//  Copyright (c) 2023 GetPregnancy. All rights reserved.
//

import UIKit

import SnapKit

final class GetPregnancyViewController: UIViewController {
    
    private let aa: UILabel = {
        let label = UILabel()
        label.text = "sagasgasgasg"
        label.textColor = .designSystem(.white)
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

private extension GetPregnancyViewController {
    func setUI() {
        view.backgroundColor = .gray
    }
    
    func setHierarchy() {
        view.addSubview(aa)
        aa.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setLayout() {
        
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
}
