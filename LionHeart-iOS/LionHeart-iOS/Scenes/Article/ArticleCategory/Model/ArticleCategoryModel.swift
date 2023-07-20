//
//  ArticleCategoryModel.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/11.
//

import UIKit

struct CategoryImage: AppData {
    let image: UIImage
    let infoDdescription: String
    let categoryString: String
}

extension CategoryImage {

    static func dummy() -> [CategoryImage] {
        return [
            .init(image: ImageLiterals.ArticleCategory.budgetCategory, infoDdescription: "예산", categoryString: "BUDGET"),
            .init(image: ImageLiterals.ArticleCategory.physicalCategory, infoDdescription: "신체 변화", categoryString: "PHYSICAL_CHANGE"),
            .init(image: ImageLiterals.ArticleCategory.coupleCategory, infoDdescription: "부부 관계", categoryString: "MARITAL_RELATIONSHIP"),
            .init(image: ImageLiterals.ArticleCategory.hospitalCategory, infoDdescription: "병원 정보", categoryString: "HOSPITAL_INFORMATION"),
            .init(image: ImageLiterals.ArticleCategory.systemCategory, infoDdescription: "지원 제도", categoryString: "SUPPORT_SYSTEM"),
            .init(image: ImageLiterals.ArticleCategory.prenatalCategory, infoDdescription: "태교", categoryString: "PRENATAL_EDUCATION"),
            .init(image: ImageLiterals.ArticleCategory.babyProductCategory, infoDdescription: "아기 용품", categoryString: "BABY_GOODS"),
            .init(image: ImageLiterals.ArticleCategory.daddyTipCategory, infoDdescription: "아빠들의 팁", categoryString: "DAD_TIPS")
        ]
    }
}
