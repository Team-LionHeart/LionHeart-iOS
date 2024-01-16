//
//  TestComponent.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 1/16/24.
//

import UIKit

import Carbon
import SnapKit

struct HelloItem: IdentifiableComponent {
    var title: String
    var id: String {
        return title
    }

    func render(in content: HelloContent) {
        content.nameLabel.text = title
    }

    func renderContent() -> HelloContent {
        return .init()
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return .init(width: UIScreen.main.bounds.width, height: 200)
    }
}


final class HelloContent: UIView {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    init() {
        super.init(frame: .zero)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
