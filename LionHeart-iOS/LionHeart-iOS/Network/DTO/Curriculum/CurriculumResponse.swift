//
//  CurriculumResponse.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/19.
//

import UIKit

struct CurriculumResponse: DTO, Response {
    
    let week: Int
    let day: Int
    let progress: Int
    let remainingDay: Int
    
}

struct CurriculumListByWeekResponse: DTO, Response {
    
    let categoryArticles: [CategoryArticle]
    
}

struct CategoryArticle: Response {
    
    let articleId: Int
    let title: String
    let mainImageUrl: String
    let firstBodyContent: String
    let requiredTime: Int
    let isMarked: Bool
    let tags: [String]
    
}

