//
//  BookmarkService.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/17.
//

import Foundation

/// 내 북마크
protocol BookmarkInOutServiceProtocol {
    func postBookmark(model: BookmarkRequest) async throws
    func getBookmark() async throws -> BookmarkAppData
}

// 동뷰, 성뷰
protocol BookmarkOutProtocol {
    func postBookmark(model: BookmarkRequest) async throws
}

final class BookmarkService: BookmarkInOutServiceProtocol, BookmarkOutProtocol {
    
    private let bookmarkAPIProtocol: BookmarkAPIProtocol
    
    init(bookmarkAPIProtocol: BookmarkAPIProtocol) {
        self.bookmarkAPIProtocol = bookmarkAPIProtocol
    }
    
    func postBookmark(model: BookmarkRequest) async throws {
        guard let data = try await bookmarkAPIProtocol.postBookmark(model: model) else { return }
        print(data)
    }
    
    func getBookmark() async throws -> BookmarkAppData {
        guard let data = try await bookmarkAPIProtocol.getBookmark() else { return BookmarkAppData(nickName: "", articleSummaries: [])}
        return data.toAppData()
    }
    
    /*
     기존의 코드 : 네트워크 요청, URLSession 통신, decode, appData return을 하나의 메서드에서 실행함
     */
    
//    func getBookmark() async throws -> BookmarkAppData {
//        let urlRequest = try NetworkRequest(path: "/v1/article/bookmarks", httpMethod: .get)
//            .makeURLRequest(isLogined: true)
//
//        let (data, _) = try await URLSession.shared.data(for: urlRequest)
//
//        let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: BookmarkResponse.self)
//
//        return BookmarkAppData(nickName: model?.babyNickname ?? "",
//                               articleSummaries: model?.articleSummaries.map {
//            ArticleSummaries(title: $0.title, articleID: $0.articleId, articleImage: $0.mainImageUrl,
//                             bookmarked: $0.isMarked, tags: $0.tags)} ?? [])
//    }
    
    
//    func postBookmark(_ model: BookmarkRequest) async throws {
//        let param = model.toDictionary()
//        let body = try JSONSerialization.data(withJSONObject: param)
//
//        let urlRequest = try NetworkRequest(path: "/v1/article/bookmark", httpMethod: .post, body: body).makeURLRequest(isLogined: true)
//
//        let (data, _) = try await URLSession.shared.data(for: urlRequest)
//        try dataDecodeAndhandleErrorCode(data: data, decodeType: String.self)
//
//        return
//    }
}
