//
//  CurriculumListByWeekData.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/14.
//

import UIKit

struct CurriculumWeekData: AppData{
    let week: String
    var articleData: [ArticleDataByWeek]
}

struct ArticleDataByWeek: AppData {
    let articleReadTime: String
    let isBookmarked: Bool
    let articleTags: String
    let articleDate: String
    let articleDay: String
    let articleContent: String
    var isArticleBookmarked: Bool
}

extension CurriculumWeekData {
    // listByWeekDatas[indexPath.item]
    static func dummy() -> [CurriculumWeekData] {
        return [
        
            .init(week: "1주차", articleData: [
                .init(articleReadTime: "1분 분량", isBookmarked: false, articleTags: "태그1-1", articleDate: "2023.01.01", articleDay: "1일차", articleContent: "1-1아티클내용", isArticleBookmarked: false),
                .init(articleReadTime: "2분 분량", isBookmarked: false, articleTags: "태그1-2", articleDate: "2023.01.02", articleDay: "2일차", articleContent: "1-2아티클내용", isArticleBookmarked: false),
                .init(articleReadTime: "3분 분량", isBookmarked: false, articleTags: "태그1-3", articleDate: "2023.01.03", articleDay: "3일차", articleContent: "1-3아티클내용", isArticleBookmarked: false),
                .init(articleReadTime: "4분 분량", isBookmarked: false, articleTags: "태그1-4", articleDate: "2023.01.04", articleDay: "4일차", articleContent: "1-4아티클내용", isArticleBookmarked: false)
            ]),
            
            .init(week: "2주차", articleData: [
            
                .init(articleReadTime: "5분 분량", isBookmarked: false, articleTags: "태그2-1", articleDate: "2023.02.01", articleDay: "1일차", articleContent: "2-1아티클내용", isArticleBookmarked: false),
                .init(articleReadTime: "6분 분량", isBookmarked: false, articleTags: "태그2-2", articleDate: "2023.02.02", articleDay: "2일차", articleContent: "2-2아티클 내용", isArticleBookmarked: false),
                .init(articleReadTime: "7분 분량", isBookmarked: false, articleTags: "태그2-3", articleDate: "2023.02.03", articleDay: "3일차", articleContent: "2-3아티클 내용", isArticleBookmarked: false),
                .init(articleReadTime: "8분 분량", isBookmarked: false, articleTags: "태그2-4", articleDate: "2023.02.04", articleDay: "4일차", articleContent: "2-4아티클 내용", isArticleBookmarked: false)
            ]),
            
            .init(week: "3주차", articleData: [
                .init(articleReadTime: "1분 분량", isBookmarked: false, articleTags: "태그1-1", articleDate: "2023.01.01", articleDay: "1일차", articleContent: "1-1아티클내용", isArticleBookmarked: false),
                .init(articleReadTime: "2분 분량", isBookmarked: false, articleTags: "태그1-2", articleDate: "2023.01.02", articleDay: "2일차", articleContent: "1-2아티클내용", isArticleBookmarked: false),
                .init(articleReadTime: "3분 분량", isBookmarked: false, articleTags: "태그1-3", articleDate: "2023.01.03", articleDay: "3일차", articleContent: "1-3아티클내용", isArticleBookmarked: false),
                .init(articleReadTime: "4분 분량", isBookmarked: false, articleTags: "태그1-4", articleDate: "2023.01.04", articleDay: "4일차", articleContent: "1-4아티클내용", isArticleBookmarked: false)
            ]),
            
                .init(week: "4주차", articleData: [
                    .init(articleReadTime: "1분 분량", isBookmarked: false, articleTags: "태그1-1", articleDate: "2023.01.01", articleDay: "1일차", articleContent: "1-1아티클내용", isArticleBookmarked: false),
                    .init(articleReadTime: "2분 분량", isBookmarked: false, articleTags: "태그1-2", articleDate: "2023.01.02", articleDay: "2일차", articleContent: "1-2아티클내용", isArticleBookmarked: false),
                    .init(articleReadTime: "3분 분량", isBookmarked: false, articleTags: "태그1-3", articleDate: "2023.01.03", articleDay: "3일차", articleContent: "1-3아티클내용", isArticleBookmarked: false),
                    .init(articleReadTime: "4분 분량", isBookmarked: false, articleTags: "태그1-4", articleDate: "2023.01.04", articleDay: "4일차", articleContent: "1-4아티클내용", isArticleBookmarked: false)
                ])
                
        ]
    }
}
