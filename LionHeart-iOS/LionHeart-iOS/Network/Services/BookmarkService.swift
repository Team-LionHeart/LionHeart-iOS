//
//  BookmarkService.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/17.
//

import Foundation

final class BookmarkService: Serviceable {
    static let shared = BookmarkService()
    private init() {}
    
    func getBookmark() async throws -> BookmarkAppData {
        let urlRequest = try NetworkRequest(path: "/v1/article/bookmarks", httpMethod: .get)
            .makeURLRequest(isLogined: true)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let model = try handleErrorCode(data: data, decodeType: BookmarkResponse.self)
        
        return BookmarkAppData(nickName: model?.babyNickname,
                               articleSummaries: model?.articleSummaries.map {
            ArticleSummaries(title: $0.title, articleImage: $0.mainImageUrl,
                             bookmarked: $0.isMarked, tags: $0.tags)})
    }
}