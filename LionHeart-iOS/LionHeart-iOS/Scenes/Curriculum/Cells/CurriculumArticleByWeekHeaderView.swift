//
//  CurriculumArticleByWeekHeaderView.swift
//  LionHeart-iOS
//
//  Created by 김의성 on 2023/11/21.
//  Copyright (c) 2023 CurriculumArticleByWeekRowZero. All rights reserved.
//

import UIKit
import Combine

import SnapKit

final class CurriculumArticleByWeekHeaderView: UIView {
    
    enum ButtonType { case left, right }
    
    let curriculumWeekChangeButtonTapped = PassthroughSubject<ButtonType, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var leftWeekButton = LHImageButton(setImage: ImageLiterals.Curriculum.arrowLeftWeek)
    private lazy var rightWeekButton = LHImageButton(setImage: ImageLiterals.Curriculum.arrowRightWeek)
    private let curriculumLabel = LHLabel(type: .body2R, color: .lionRed, alignment: .center, basicText: "Curriculum")
    private let weekLabel = LHLabel(type: .head1, color: .white, alignment: .center)
    private let curriculumAndWeekStackView = LHStackView(axis: .vertical, spacing: 2)
    private let weekBackGroundImageView = LHImageView(contentMode: .scaleAspectFill)

    private let blurblackView = LHView(color: .designSystem(.black)?.withAlphaComponent(0.4))

    var inputData: Int? {
        didSet {
            guard let inputData else { return }
            weekLabel.text = "\(inputData)주차"
            weekBackGroundImageView.image = WeekBackgroundImage.dummy()[inputData-4].weekBackgroundImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setHierarchy()
        setLayout()
        setAddTarget()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CurriculumArticleByWeekHeaderView {
    
    func setUI() {
        weekBackGroundImageView.backgroundColor = .designSystem(.gray500)
        weekBackGroundImageView.isUserInteractionEnabled = true
    }

    func setHierarchy() {
        curriculumAndWeekStackView.addArrangedSubviews(curriculumLabel, weekLabel)
        weekBackGroundImageView.addSubviews(blurblackView, curriculumAndWeekStackView)
        addSubviews(weekBackGroundImageView, leftWeekButton, rightWeekButton)
    }
    
    func setLayout() {
        weekBackGroundImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
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
        leftWeekButton.tapPublisher
            .sink { [weak self] in
                self?.curriculumWeekChangeButtonTapped.send(.left)
            }
            .store(in: &cancelBag)
        
        rightWeekButton.tapPublisher
            .sink { [weak self] in
                self?.curriculumWeekChangeButtonTapped.send(.right)
            }
            .store(in: &cancelBag)
    }
}
