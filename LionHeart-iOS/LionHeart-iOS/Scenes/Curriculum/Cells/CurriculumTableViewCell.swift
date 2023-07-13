//
//  CurriculumTableViewCell.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Curriculum. All rights reserved.
//

import UIKit

import SnapKit

protocol CurriculumTableViewToggleButtonTappedProtocol: AnyObject {
    func toggleButtonTapped(indexPath: IndexPath?)
}

final class CurriculumTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {
    
    weak var delegate: CurriculumTableViewToggleButtonTappedProtocol?
    
    var cellIndexPath: IndexPath?
    
    private enum Size {
        static let contentImageView: CGFloat = 120 / 335
    }
    
    private let curriculumWeekLableView = UIView()
    
    private let curriculumWholeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private let curriculumContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let weekLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2M)
        label.textColor = .designSystem(.gray500)
        label.backgroundColor = .designSystem(.background)
        return label
    }()
    
    private let weekTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.gray100)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.textAlignment = .left
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
        var button = UIButton()
        button.setImage(UIImage(named: "Vector1"), for: .normal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.addButtonAction { _ in
            self.delegate?.toggleButtonTapped(indexPath: self.cellIndexPath)
        }
        return button
    }()
    
    
    var inputData: CurriculumDummyData? {
        didSet {
            guard let inputData else { return }
            self.weekLabel.text = inputData.curriculumWeek
            self.weekTitleLabel.text = inputData.curriculumWeekTitle
            self.contentImageView.image = inputData.curriculumImage
            self.contentTextLabel.text = inputData.curriculumText
            self.curriculumContentStackView.isHidden = !inputData.isHidden // false -> true -> 안보이게됨
            self.weekLabel.textColor = inputData.isHidden
            ? .designSystem(.componentLionRed)
            : .designSystem(.gray500)
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
        
        curriculumWeekLableView.addSubviews(weekLabel, weekTitleLabel, curriculumToggleDirectionButton)
        curriculumContentStackView.addArrangedSubviews(contentImageView, contentTextLabel)
        curriculumWholeStackView.addArrangedSubviews(curriculumWeekLableView, curriculumContentStackView)
        contentView.addSubviews(curriculumWholeStackView, divider)
        
    }
    
    func setLayout() {
    
        weekLabel.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        weekTitleLabel.snp.makeConstraints{
            $0.centerY.equalTo(weekLabel)
            $0.leading.equalTo(weekLabel.snp.trailing).offset(8).priority(.high)
        }
        
        curriculumToggleDirectionButton.snp.makeConstraints{
            $0.leading.greaterThanOrEqualTo(weekTitleLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(weekLabel)
            $0.trailing.equalToSuperview()
        }
        
        curriculumWholeStackView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        divider.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
        
        contentImageView.snp.makeConstraints{
            $0.height.equalTo(contentImageView.snp.width).multipliedBy(Size.contentImageView)
        }
    }
}
