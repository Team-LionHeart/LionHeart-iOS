//
//  UITabbarItem+.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/22.
//

import UIKit

extension UITabBarItem {
    enum TabType {
        case today, category, curriculum, challenge
        
        var tabbarElements: (title: String, image: UIImage?, tag: Int) {
            switch self {
            case .today: return (title: "투데이", image: UIImage.assetImage(.home), tag: 0)
            case .category: return (title: "탐색", image: UIImage.assetImage(.search), tag: 1)
            case .curriculum: return (title: "커리큘럼", image: UIImage.assetImage(.curriculum), tag: 2)
            case .challenge: return (title: "챌린지", image: UIImage.assetImage(.challenge), tag: 3)
            }
        }
    }
    
    static func makeTabItem(_ type: TabType) -> UITabBarItem {
        return UITabBarItem(title: type.tabbarElements.title, image: type.tabbarElements.image, tag: type.tabbarElements.tag)
    }
}
