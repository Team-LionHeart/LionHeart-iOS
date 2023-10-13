//
//  TabBarViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 TabBar. All rights reserved.
//

import UIKit

import SnapKit

final class TabBarViewController: UITabBarController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        
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
