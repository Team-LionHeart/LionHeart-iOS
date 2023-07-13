//
//  ArticleCategoryModel.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/11.
//

import UIKit

struct CategoryImage:AppData {
    let image: UIImage
    let infoDdescription: String
}

extension CategoryImage {
    static func dummy() -> [CategoryImage] {
        var images: [CategoryImage] = []
        let descriptions = ["예산", "신체 변화", "부부 관계", "병원 정보", "지원 제도", "태교", "아기 용품", "아빠들의 팁"]
        
        for number in 1...8 {
            images.append(CategoryImage(image: UIImage(named: "Category_\(number)") ?? UIImage(), infoDdescription: descriptions[number - 1]))
        }
        return images
    }
}
