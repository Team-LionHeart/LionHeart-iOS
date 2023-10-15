//
//  CurriculumControllerable.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation


protocol CurriculumControllerable: ViewControllerable {
    var articleId: Int { get set }
    var itemIndex: Int { get set }
}
