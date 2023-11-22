//
//  TabBarViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 TabBar. All rights reserved.
//

import UIKit

import SnapKit

protocol Tabbar {
    var load: ((UINavigationController) -> ())? { get set }
    var todayArticleTapSelected: ((UINavigationController) -> ())? { get set }
    var searchTapSelected: ((UINavigationController) -> ())? { get set }
    var curriculumTapSelected: ((UINavigationController) -> ())? { get set }
    var challengeTapSelected: ((UINavigationController) -> ())? { get set }
}

final class TabBarViewController: UITabBarController, Tabbar {
    var load: ((UINavigationController) -> ())?
    var todayArticleTapSelected: ((UINavigationController) -> ())?
    var searchTapSelected: ((UINavigationController) -> ())?
    var curriculumTapSelected: ((UINavigationController) -> ())?
    var challengeTapSelected: ((UINavigationController) -> ())?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .black
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.iconColor = .gray
        tabBarItemAppearance.selected.iconColor = .white
        tabBarItemAppearance.normal.titleTextAttributes = [ .foregroundColor : UIColor.gray, .font : UIFont.systemFont(ofSize: 9)]
        tabBarItemAppearance.selected.titleTextAttributes = [ .foregroundColor : UIColor.white, .font : UIFont.systemFont(ofSize: 9, weight: .bold)]
        tabBarAppearance.inlineLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = tabBarItemAppearance
        
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 100
        tabBar.frame.origin.y = view.frame.height - 100
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        switch selectedIndex {
        case 0:
            todayArticleTapSelected?(controller)
        case 1:
            
        case 2:
        case 3:
        default:
            break
        }
    }
}
