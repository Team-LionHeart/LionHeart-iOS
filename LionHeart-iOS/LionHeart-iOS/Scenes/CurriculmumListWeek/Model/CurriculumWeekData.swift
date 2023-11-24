//
//  CurriculumListByWeekData.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/14.
//

import UIKit

struct CurriculumWeekData: Hashable, AppData {
    var articleData: [ArticleDataByWeek]
    let week: Int?
}
