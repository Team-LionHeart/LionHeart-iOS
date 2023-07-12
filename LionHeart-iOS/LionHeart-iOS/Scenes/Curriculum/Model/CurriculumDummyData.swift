//
//  CurriculumDummyData.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/11.
//

import UIKit

struct UserInfoData: AppData{
    let fetusName: String
    let userWeekInfo: Int
    let userDayInfo: Int
}

extension UserInfoData {
    static func dummy() -> UserInfoData {
        return UserInfoData(fetusName: "곽성준", userWeekInfo: 15, userDayInfo: 3)
    }
}

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
            CurriculumMonthData(month: "2개월", weekDatas: [
            .init(curriculumWeek: "4주차", curriculumWeekTitle: "아빠가 되기 위한 9개월 로드맵", curriculumImage: UIImage(), curriculumText: "1주차 내용"),
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

