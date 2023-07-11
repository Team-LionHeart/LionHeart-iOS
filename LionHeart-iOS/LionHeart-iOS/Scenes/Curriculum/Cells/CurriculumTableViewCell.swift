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
    
//    //버튼 돌아가있는지 확인하는 버튼
//    var isButtonRotated: Bool = false
//
//    //플로팅버튼을 토글 버튼처럼 활용하기 위한 bool 변수
//    var floatingButtonTapped: Bool = false

    private enum Size {
        static let contentImageView: CGFloat = 120 / 335
    }
    
    let curriculumWholeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
       return stackView
    }()
    
    private let curriculumWeekLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
       return stackView
    }()
    
    private let curriculumContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
//        stackView.isHidden = true
        return stackView
    }()
    
    private let weekLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2M)
        label.textColor = .designSystem(.gray500)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.backgroundColor = .designSystem(.background)
        return label
    }()
    private let weekTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.gray100)
        return label
    }()
    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .designSystem(.lionRed)
        return imageView
    }()
    private let contentTextLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body3R)
        label.textColor = .designSystem(.gray500)
        label.numberOfLines = 0
       return label
    }()
    
    private let divider: UIView = {
        let line = UIView()
        line.backgroundColor = .designSystem(.gray800)
       return line
    }()
    
    lazy var curriculumToggleDirectionButton: UIButton = {
        lazy var button = UIButton()
        button.setImage(UIImage(named: "Vector1"), for: .normal)
       return button
    }()
    
    var inputData: CurriculumDummyData? {
        didSet {
            self.weekLabel.text = inputData?.curriculumWeek
            self.weekTitleLabel.text = inputData?.curriculumWeekTitle
            self.contentImageView.image = inputData?.curriculumImage
            self.contentTextLabel.text = inputData?.curriculumText
            
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
        self.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        contentView.addSubviews(curriculumWholeStackView, divider, curriculumToggleDirectionButton)
        curriculumWholeStackView.addArrangedSubviews(curriculumWeekLabelStackView, curriculumContentStackView)
        curriculumWeekLabelStackView.addArrangedSubviews(weekLabel, weekTitleLabel)
        curriculumContentStackView.addArrangedSubviews(contentImageView, contentTextLabel)
    }
    
    func setLayout() {
        
        curriculumToggleDirectionButton.snp.makeConstraints{
            $0.top.equalTo(curriculumWholeStackView.snp.top).inset(0.6)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        curriculumWholeStackView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        curriculumWeekLabelStackView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        divider.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
        
        curriculumContentStackView.snp.makeConstraints{
            $0.top.equalTo(curriculumWeekLabelStackView.snp.bottom).inset(-15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentImageView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(Constant.Screen.width - 40)
            $0.height.equalTo(contentImageView.snp.width).multipliedBy(Size.contentImageView)
        }
        
        contentTextLabel.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(36)
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        
    }
    
    //버튼 돌아가는 애니메이션
//    func rotateFloatingButton() {
//        let rotationAngle: CGFloat = isButtonRotated ? 0.0 : .pi / 2.0
//        UIView.animate(withDuration: 0.4) {
//            self.curriculumToggleDirectionButton.transform = CGAffineTransform(rotationAngle: rotationAngle)
//        }
//        isButtonRotated.toggle()
//    }
}
