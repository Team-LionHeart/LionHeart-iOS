//
//  CurriculumArticleByWeekRowZeroTableViewCell.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/14.
//  Copyright (c) 2023 CurriculumArticleByWeekRowZero. All rights reserved.
//

import UIKit

import SnapKit

final class CurriculumArticleByWeekRowZeroTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {
    
    private enum Size {
        static let weekBackGroundImageSize: CGFloat = 200 / 375
    }
    
    private let weekBackGroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .designSystem(.gray500)
        return imageView
    }()
    
    private lazy var leftWeekButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Curriculum.arrowLeftWeek, for: .normal)
        return button
    }()
    
    private lazy var rightWeekButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.Curriculum.arrowRightWeek, for: .normal)
        return button
    }()
    
    private let curriculumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.lionRed)
        label.text = "Curriculum"
        return label
    }()
    
    private let weekLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head1)
        label.textColor = .designSystem(.white)
        label.textAlignment = .center
        label.text = "shfjashfisahilfhsu"
        return label
    }()
    
    private let curriculumAndWeekStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.spacing = 2
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
       
    var inputData: CurriculumWeekData? {
        didSet {
            weekLabel.text = inputData?.week
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CurriculumArticleByWeekRowZeroTableViewCell {
    func setUI() {
    }
    
    func setHierarchy() {
        curriculumAndWeekStackView.addArrangedSubviews(weekLabel, curriculumLabel)
        
        weekBackGroundImageView.addSubviews(leftWeekButton, rightWeekButton, curriculumAndWeekStackView)
        
        self.addSubviews(weekBackGroundImageView)
    }
    
    func setLayout() {
        
        weekBackGroundImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.height.equalTo(weekBackGroundImageView.snp.width).multipliedBy(Size.weekBackGroundImageSize)
        }
        
        leftWeekButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        rightWeekButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        curriculumAndWeekStackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
}
