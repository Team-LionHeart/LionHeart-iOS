//
//  ImageLiterals.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/13.
//

import UIKit

enum ImageLiterals {
    enum Article {
        static var icFab: UIImage { .load(named: "ic_fab") }
    }

    enum Splash {
        static var splashLogo: UIImage { .load(named: "splash_image") }

    }

    enum ArticleCategory {
        static var babyProductCategory: UIImage { .load(named: "baby_product_category") }
        static var budgetCategory: UIImage { .load(named: "budget_category") }
        static var coupleCategory: UIImage { .load(named: "couple_category") }
        static var hospitalCategory: UIImage { .load(named: "hospital_category") }
        static var physicalCategory: UIImage { .load(named: "physical_category") }
        static var prenatalCategory: UIImage { .load(named: "prenatal_category") }
        static var systemCategory: UIImage { .load(named: "system_category") }
        static var daddyTipCategory: UIImage { .load(named: "daddy_tip_category") }
    }

    enum BookMark {
        static var activeBookmarkBig: UIImage { .load(named: "ic_bookmark_active_big") }
        static var inactiveBookmarkBig: UIImage { .load(named: "ic_bookmark_inactive_big") }

        static var activeBookmarkSmall: UIImage { .load(named: "ic_bookmark_active_small") }
        static var inactiveBookmarkSmall: UIImage { .load(named: "ic_bookmark_inactive_small") }
    }

    enum Curriculum {
        static var arrowDownSmall: UIImage { .load(named: "ic_arrow_down_small") }
        static var arrowUpSmall: UIImage { .load(named: "ic_arrow_up_small") }

        static var arrowLeftWeek: UIImage { .load(named: "ic_arrow_left_round") }
        static var arrowRightWeek: UIImage { .load(named: "ic_arrow_right_round") }

        static var arrowRightCircle: UIImage { .load(named: "ic_arrow_right_circle") }

        static var arrowRightSmall: UIImage { .load(named: "ic_arrow_right_small") }

        static var dayBackground: UIImage { .load(named: "day_background") }
        static var weekBackground: UIImage { .load(named: "week_background") }
    }

    enum MyPage {
        static var newIcon: UIImage { .load(named: "ic_new") }
        static var penIcon: UIImage { .load(named: "ic_pen") }
        static var penColorIcon: UIImage { .load(named: "ic_pen_color") }
    }

    enum NavigationBar {
        static var arrowBack: UIImage { .load(named: "ic_arrow_back") }
        static var bookMark: UIImage { .load(named: "ic_bookmark") }
        static var profile: UIImage { .load(named: "ic_profile") }
        static var closeBack: UIImage { .load(named: "ic_X_back") }
    }

    enum TabBar {
        static var challenge: UIImage { .load(named: "ic_challenge") }
        static var curriculum: UIImage { .load(named: "ic_curriculum") }
        static var home: UIImage { .load(named: "ic_home") }
        static var search: UIImage { .load(named: "ic_search") }
    }

    enum Toast {
        static var lionHeartLogoSmall: UIImage { .load(named: "ic_logo_small") }
    }

    enum Today {
        static var lionHeartLogoBig: UIImage { .load(named: "ic_logo_big") }
    }
    
    enum ChallengeBadge {
        static var level01: UIImage { .load(named: "ic_badge_level1") }
        static var level02: UIImage { .load(named: "ic_badge_level2") }
        static var level03: UIImage { .load(named: "ic_badge_level3") }
        static var level04: UIImage { .load(named: "ic_badge_level4") }
        static var level05: UIImage { .load(named: "ic_badge_level5") }
    }
}


extension UIImage {
    static func load(named imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        return image
    }
}
