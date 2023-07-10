//
//  NavigationBarLayoutManager.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/10.
//

import UIKit

final class NavigationBarLayoutManager {
    static func add(_ naviView: LHNavigationBarView) {

        guard let currentViewController = UIApplication.navigationTopViewController() else { return }

        currentViewController.view.addSubview(naviView)
        currentViewController.navigationController?.navigationBar.isHidden = true
        naviView.snp.makeConstraints { make in
            make.top.equalTo(currentViewController.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
}
