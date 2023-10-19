//
//  CurriculumArticleByWeekControllerable.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import UIKit


protocol CurriculumArticleByWeekControllerable where Self: UIViewController {
    func setWeekIndexPath(week: Int)
    var navigator: CurriculumListByWeekNavigation { get set }
}
