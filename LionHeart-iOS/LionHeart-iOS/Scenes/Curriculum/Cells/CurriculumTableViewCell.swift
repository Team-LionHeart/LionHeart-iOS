//
//  CurriculumTableViewCell.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Curriculum. All rights reserved.
//

import UIKit

import SnapKit

final class CurriculumTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {
    
    private enum Size {
        static let widthRatio: CGFloat = 120 / 335
    }
    
    private let week: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2M)
        label.textColor = .designSystem(.gray500)
        return label
    }()
    private let weekTitle: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.gray100)
        return label
    }()
    private let contextImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    private let contextText: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray500)
        label.numberOfLines = 0
       return label
    }()
    
    var inputData: CurriculumDummyData? {
        didSet {
            self.week.text = inputData?.curriculumWeek
            self.weekTitle.text = inputData?.curriculumWeekTitle
            self.contextImage.image = inputData?.curriculumImage
            self.contextText.text = inputData?.curriculumText
            
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

private extension CurriculumTableViewCell {
    func setUI() {
        
    }
    
    func setHierarchy() {
        contentView.addSubviews(week,weekTitle,contextImage,contextText)
    }
    
    func setLayout() {
        week.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(17)
        }
        
        weekTitle.snp.makeConstraints{
            $0.leading.equalTo(week.snp.trailing).offset(8)
            $0.centerY.equalTo(week)
        }
        
        contextImage.snp.makeConstraints{
            $0.top.equalTo(weekTitle.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Constant.Screen.width - 40)
            $0.height.equalTo(contextImage.snp.width).multipliedBy(Size.widthRatio)
        }
        
        contextText.snp.makeConstraints{
            $0.top.equalTo(contextImage.snp.bottom).offset(12)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
}
