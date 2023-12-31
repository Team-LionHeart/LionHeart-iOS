//
//  CurriculumTableViewCell.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Curriculum. All rights reserved.
//

import UIKit
import Combine

import SnapKit

final class CurriculumTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {
    
    var rightArrowButtonTapped = PassthroughSubject<Void, Never>()
    var cancelBag = Set<AnyCancellable>()
    
    private let curriculumWeekLabelView = UIView()
    private let curriculumWholeStackView = LHStackView(axis: .vertical, spacing: 15)
    private let curriculumContentStackView = LHStackView(axis: .vertical, spacing: 12)
    private let weekLabel = LHLabel(type: .body2M, color: .gray500, backgroundColor: .background)
    private let weekTitleLabel = LHLabel(type: .body2R, color: .gray100, alignment: .left)
    private let contentTextLabel = LHLabel(type: .body3R, color: .gray500, lines: 0)
    private let contentImageView = LHImageView(contentMode: .scaleToFill)
    private let divider = LHUnderLine(lineColor: .gray800)
    private var moveToArticleListByWeekButton = LHImageButton(setImage: ImageLiterals.Curriculum.arrowRightCircle)
    
    var inputData: CurriculumDummyData? {
        didSet {
            guard let inputData else { return }
            configureData(inputData)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setHierarchy()
        setLayout()
        bindInput()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelBag.removeAll()
    }
}

private extension CurriculumTableViewCell {
    
    enum Size {
        static let contentImageView: CGFloat = 120 / 335
    }
    
    func setUI() {
        self.backgroundColor = .designSystem(.background)
        weekTitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentImageView.isUserInteractionEnabled = true
    }
    
    func setHierarchy() {
        curriculumWeekLabelView.addSubviews(weekLabel, weekTitleLabel)
        contentImageView.addSubviews(moveToArticleListByWeekButton)
        curriculumContentStackView.addArrangedSubviews(contentImageView, contentTextLabel)
        curriculumWholeStackView.addArrangedSubviews(curriculumWeekLabelView, curriculumContentStackView)
        contentView.addSubviews(curriculumWholeStackView, divider)
    }
    
    func setLayout() {
        weekLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        weekTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(weekLabel)
            $0.leading.equalTo(weekLabel.snp.trailing).offset(8).priority(.high)
        }
    
        
        curriculumWholeStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        divider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
        
        contentImageView.snp.makeConstraints {
            $0.height.equalTo(contentImageView.snp.width).multipliedBy(Size.contentImageView)
        }
        
        moveToArticleListByWeekButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    func bindInput() {
        moveToArticleListByWeekButton.addButtonAction { sender in
            self.rightArrowButtonTapped.send(())
        }
    }
    
    func configureData(_ inputData: CurriculumDummyData) {
        self.weekLabel.text = inputData.curriculumWeek
        self.weekTitleLabel.text = inputData.curriculumWeekTitle
        self.contentImageView.image = inputData.curriculumImage
        self.contentTextLabel.text = inputData.curriculumText
        self.contentTextLabel.setTextWithLineHeight(lineHeight: 22)
        self.weekLabel.textColor = inputData.isExpanded ? .designSystem(.componentLionRed) : .designSystem(.gray500)
    }
}
