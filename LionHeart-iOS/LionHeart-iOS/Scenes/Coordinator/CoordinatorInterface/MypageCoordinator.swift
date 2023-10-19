//
//  MypageCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

protocol MyPageCoordinator: Coordinator {
    func showMyPageViewController()
    func exitApplication()
    func pop()
}
