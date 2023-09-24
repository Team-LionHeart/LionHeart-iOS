//
//  BookmarkAPI.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/09/13.
//

//import Foundation
//
//protocol BookmarkAPIProtocol {
//    func getBookmark() async throws -> BookmarkResponse?
//    func postBookmark(model: BookmarkRequest) async throws -> BookmarkResponse?
//}
//
//final class BookmarkAPI: BookmarkAPIProtocol {
//    
//    private let apiService: Requestable
//    
//    init(apiService: Requestable) {
//        self.apiService = apiService
//    }
//    
//    func getBookmark() async throws -> BookmarkResponse? {
//        let request = try makeGetBookmarkUrlRequest()
//        return try await apiService.request(request)
//    }
//    
//    func postBookmark(model: BookmarkRequest) async throws -> BookmarkResponse? {
//        let request = try makePostBookmakrUrlRequest(model: model)
//        return try await apiService.request(request)
//    }
//}
//
//
///// url request method
//extension BookmarkAPI {
//    func makeGetBookmarkUrlRequest() throws -> URLRequest {
//        return try NetworkRequest(path: "/v1/article/bookmarks", httpMethod: .get).makeURLRequest(isLogined: true)
//    }
//    
//    func makePostBookmakrUrlRequest(model: BookmarkRequest) throws -> URLRequest {
//        let param = model.toDictionary()
//        let body = try JSONSerialization.data(withJSONObject: param)
//        
//        return try NetworkRequest(path: "/v1/article/bookmark", httpMethod: .post, body: body).makeURLRequest(isLogined: true)
//    }
//}
