//
//  CurriculumResponse.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/19.
//

import Foundation

struct CurriculumResponse: DTO, Response {
    
    let week: Int
    let day: Int
    let progress: Int
    let remainingDay: Int

}
