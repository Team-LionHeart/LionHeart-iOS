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
    
    var cellIndexPath: IndexPath?

    var indexPathData: IndexPath?{
        didSet{
            cellIndexPath = indexPathData
        }
    }
    
    var inputData: CurriculumWeekData? {
        didSet {
            weekLabel.text = inputData?.week
        }
    }
    
    private enum Size {
        static let weekBackGroundImageSize: CGFloat = 200 / 375
    }
        
    private let weekBackGroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .designSystem(.gray500)
        return imageView
    }()
    
    private lazy var leftWeekButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(ImageLiterals.Curriculum.arrowLeftWeek, for: .normal)
        button.addButtonAction { _ in

        NotificationCenter.default.post(name: NSNotification.Name("leftButton"),
                                            object: -1)
        }
        return button
    }()
    
    private lazy var rightWeekButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(ImageLiterals.Curriculum.arrowRightWeek, for: .normal)
        button.addButtonAction { _ in
            NotificationCenter.default.post(name: NSNotification.Name("rightButton"),
                                            object: 1)
        }
        
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
        return label
    }()
    
    private let curriculumAndWeekStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.spacing = 2
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()

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
        

        curriculumAndWeekStackView.addArrangedSubviews(curriculumLabel, weekLabel)
        weekBackGroundImageView.addSubviews(curriculumAndWeekStackView)
        contentView.addSubviews(weekBackGroundImageView, leftWeekButton, rightWeekButton)

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