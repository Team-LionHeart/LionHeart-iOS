//
//  LHNavigationBarView.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/09.
//

import UIKit

final class LHNavigationBarView: UIView {

    private let titleLabel = LHLabel(type: .head4, color: .white)
    
    private let leftBarItem: UIButton = {
        let button = UIButton()
        button.tintColor = .designSystem(.white)
        button.marginImageWithText(margin: 14)
        return button
    }()

    private let rightFirstBarItem: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.NavigationBar.bookMark, for: .normal)
        button.tintColor = .designSystem(.white)
        button.marginImageWithText(margin: 14)
        return button
    }()

    private let rightSecondBarItem: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.NavigationBar.profile, for: .normal)
        button.tintColor = .designSystem(.white)
        button.marginImageWithText(margin: 14)
        return button
    }()
    
    private let graySepartorLine = LHUnderLine(lineColor: .gray800)

    private lazy var rightBarItemsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            rightFirstBarItem, rightSecondBarItem
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.isHidden = true
        return stackView
    }()

    private let type: LHNavigationType

    private weak var viewController: UIViewController?

    private var rightFirstBarItemHandler: (() -> Void)?
    private var rightSecondBarItemHandler: (() -> Void)?
    private var backButtonActionHandler: (() -> Void)?

    init(type: LHNavigationType, viewController: UIViewController) {
        self.type = type
        self.viewController = viewController
        super.init(frame: .zero)
        setStyle()
        setHierarchy()
        setLayout()
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStyle() {
        self.backgroundColor = type.backgroundColor
    }

    private func setHierarchy() {
        self.addSubviews(leftBarItem,
                         titleLabel,
                         rightBarItemsStackView,
                         graySepartorLine)
    }

    private func setLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(ScreenUtils.getHeight(60))
        }
        
        leftBarItem.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(leftBarItem)
        }

        rightBarItemsStackView.snp.makeConstraints { make in
            make.centerY.equalTo(leftBarItem)
            make.trailing.equalToSuperview().inset(16)
        }

        graySepartorLine.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    private func setUI() {
        switch type.leftBarItemType {
        case .backButtonWithTitle:
            setBackButtonWithTitle()
        case .buttonWithRightBarItems:
            setButtonWithRightBarItems()
        case .closeButtonWithTitle:
            setCloseButtonWithTitle()
        }
    }

    private func setBackButtonWithTitle() {
        self.titleLabel.text = type.title
        self.leftBarItem.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        self.leftBarItem.addButtonAction { _ in
            self.backButtonActionHandler?()
        }
    }

    private func setButtonWithRightBarItems() {
        rightBarItemsStackView.isHidden = false

        rightFirstBarItem.addButtonAction { [weak self] _ in
            guard let self else { return }
            rightFirstBarItemHandler?()
        }
        rightSecondBarItem.addButtonAction { [weak self] _ in
            guard let self else { return }
            rightSecondBarItemHandler?()
        }

        if type == .today {
            leftBarItem.setImage(ImageLiterals.Today.lionHeartLogoBig, for: .normal)
            return
        }
        leftBarItem.setTitle(type.title, for: .normal)
        leftBarItem.titleLabel?.font = .pretendard(.head4)
    }

    private func setCloseButtonWithTitle() {
        self.titleLabel.text = type.title
        self.leftBarItem.setImage(UIImage(systemName: "xmark"), for: .normal)
        self.leftBarItem.addButtonAction { [weak self] _ in
            guard let self else { return }
            self.backButtonActionHandler?()
        }
    }
}

extension LHNavigationBarView {
    @discardableResult
    func backButtonAction(_ handler: @escaping (() -> Void)) -> Self {
        self.backButtonActionHandler = handler
        return self
    }
    /// 주차별 커리큘럼의 NavigationBar에는 클릭한 cell의 주차 정보가 포함되어 있어 이 메서드로 설정.
    /// - Parameter week: 주차 커리큘럼에서 주차를 설정하기 위한 인자값.
    func setCurriculumWeek(week: Int) {
        self.titleLabel.text = "\(week)주차 커리큘럼"
    }
    
    @discardableResult
    /// NavigationBar의 RightBarItems중 왼쪽에 해당하는 아이콘을 눌렀을 때의 Action을 정의하는 메서드.
    /// - Parameter handler: 해당 아이콘을 눌렀을 때 필요한 로직을 담은 클로저
    /// - Returns: LHNavigationBarView타입을 돌려주기 때문에 체이닝으로 연속해서 메서드를 호출가능.
    func rightFirstBarItemAction(_ handler: @escaping (() -> Void)) -> Self {
        self.rightFirstBarItemHandler = handler
        return self
    }

    @discardableResult
    /// NavigationBar의 RightBarItems중 오른쪽에 해당하는 아이콘을 눌렀을 때의 Action을 정의하는 메서드.
    /// - Parameter handler: 해당 아이콘을 눌렀을 때 필요한 로직을 담은 클로저
    /// - Returns: LHNavigationBarView타입을 돌려주기 때문에 체이닝으로 연속해서 메서드를 호출가능.
    func rightSecondBarItemAction(_ handler: @escaping (() -> Void)) -> Self {
        self.rightSecondBarItemHandler = handler
        return self
    }
}
