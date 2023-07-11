//
//  CurriculumDummyData.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/11.
//

import UIKit


struct CurriculumMonthData: AppData{
    let month: String
    let weekDatas: [CurriculumDummyData]
}

struct CurriculumDummyData: AppData {
    let curriculumWeek: String
    let curriculumWeekTitle: String
    let curriculumImage: UIImage
    let curriculumText: String
}
extension CurriculumMonthData {
    static func dummy() -> [CurriculumMonthData] {
        return [
            CurriculumMonthData(month: "1개월", weekDatas: [
            .init(curriculumWeek: "1주차", curriculumWeekTitle: "1주차 제목", curriculumImage: UIImage(), curriculumText: "1주차 내용"),
            .init(curriculumWeek: "2주차", curriculumWeekTitle: "2주차 제목", curriculumImage: UIImage(), curriculumText: "2주차 내용")
        ]),
            CurriculumMonthData(month: "2개월", weekDatas: [
                    .init(curriculumWeek: "3주차", curriculumWeekTitle: "3주차 제목", curriculumImage: UIImage(), curriculumText: "3주차 내용"),
                    .init(curriculumWeek: "4주차", curriculumWeekTitle: "4주차 제목", curriculumImage: UIImage(), curriculumText: "4주차 내용")
                ]),
                .init(month: "3개월", weekDatas: [
                    .init(curriculumWeek: "5주차", curriculumWeekTitle: "5주차 제목", curriculumImage: UIImage(), curriculumText: "5주차 내용"),
                    .init(curriculumWeek: "6주차", curriculumWeekTitle: "6주차 제목", curriculumImage: UIImage(), curriculumText: "6주차 내용")
                ]),
                .init(month: "4개월", weekDatas: [
                    .init(curriculumWeek: "7주차", curriculumWeekTitle: "7주차 제목", curriculumImage: UIImage(), curriculumText: "7주차 내용"),
                    .init(curriculumWeek: "8주차", curriculumWeekTitle: "8주차 제목", curriculumImage: UIImage(), curriculumText: "8주차 내용")
                ])
        ]
    }
}


