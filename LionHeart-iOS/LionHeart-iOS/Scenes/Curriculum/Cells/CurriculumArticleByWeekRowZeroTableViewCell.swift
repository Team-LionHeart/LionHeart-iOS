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
    
    private lazy var leftWeekButton = LHImageButton(setImage: ImageLiterals.Curriculum.arrowLeftWeek)
    private lazy var rightWeekButton = LHImageButton(setImage: ImageLiterals.Curriculum.arrowRightWeek)
    private let curriculumLabel = LHLabel(type: .body2R, color: .lionRed, alignment: .center, basicText: "Curriculum")
    private let weekLabel = LHLabel(type: .head1, color: .white, alignment: .center)
    private let curriculumAndWeekStackView = LHStackView(axis: .vertical, spacing: 2)

    private let weekBackGroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .designSystem(.gray500)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let blurblackView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.black)?.withAlphaComponent(0.4)
        return view
    }()
    
    var inputData: Int? {
        didSet {
            guard let inputData else { return }
            weekLabel.text = "\(inputData)주차"
            weekBackGroundImageView.image = WeekBackgroundImage.dummy()[inputData-4].weekBackgroundImage
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setHierarchy()
        setLayout()
        setAddTarget()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CurriculumArticleByWeekRowZeroTableViewCell {
    
    enum Size {
        static let weekBackGroundImageSize: CGFloat = 200 / 375
    }

    func setHierarchy() {
        curriculumAndWeekStackView.addArrangedSubviews(curriculumLabel, weekLabel)
        weekBackGroundImageView.addSubviews(blurblackView, curriculumAndWeekStackView)
        contentView.addSubviews(weekBackGroundImageView, leftWeekButton, rightWeekButton)
    }
    
    func setLayout() {
        weekBackGroundImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.height.equalTo(weekBackGroundImageView.snp.width).multipliedBy(Size.weekBackGroundImageSize)
        }

        blurblackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        leftWeekButton.addButtonAction { _ in
            NotificationCenter.default.post(name: NSNotification.Name("leftButton"), object: nil)
        }
        
        rightWeekButton.addButtonAction { _ in
            NotificationCenter.default.post(name: NSNotification.Name("rightButton"), object: nil)
        }
    }
}
