//
//  Constant.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//

import UIKit

enum Constant {
    struct Screen {
        public static let width = UIScreen.main.bounds.width
        public static let height = UIScreen.main.bounds.height
    }
    
    enum ImageName: String {
        
        /// TabbarImageName
        case home = "ic_home"
        case curriculum = "ic_curriculum"
        case challenge = "ic_challenge"
        case search = "ic_search"
        
        var real: String {
            return self.rawValue
        }
    }
}
