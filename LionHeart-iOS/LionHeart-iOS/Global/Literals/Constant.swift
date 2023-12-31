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
        
        /// Bookmark
        case bookmarkActiveSmall = "ic_bookmark_active_small"
        case bookmarkInactiveSmall = "ic_bookmark_inactive_small"
        
        /// Onboarding
        case textFieldClear = "ic_X_back"
        
        var real: String {
            return self.rawValue
        }
    }
}
