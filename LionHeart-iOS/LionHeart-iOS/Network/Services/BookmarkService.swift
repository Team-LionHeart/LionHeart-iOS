//
//  BookmarkService.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/17.
//

import Foundation

///// 내 북마크
//protocol BookmarkInOutServiceProtocol {
//    func postBookmark(model: BookmarkRequest) async throws
//    func getBookmark() async throws -> BookmarkAppData
//}
//
//// 동뷰, 성뷰
//protocol BookmarkOutProtocol {
//    func postBookmark(model: BookmarkRequest) async throws
//}
//
//final class BookmarkService: BookmarkInOutServiceProtocol, BookmarkOutProtocol {
//    
//    private let bookmarkAPIProtocol: BookmarkAPIProtocol
//    
//    init(bookmarkAPIProtocol: BookmarkAPIProtocol) {
//        self.bookmarkAPIProtocol = bookmarkAPIProtocol
//    }
//    
//    func postBookmark(model: BookmarkRequest) async throws {
//        guard let data = try await bookmarkAPIProtocol.postBookmark(model: model) else { return }
//        print(data)
//    }
//    
//    func getBookmark() async throws -> BookmarkAppData {
//        guard let data = try await bookmarkAPIProtocol.getBookmark() else { return BookmarkAppData(nickName: "", articleSummaries: [])}
//        return data.toAppData()
//    }
//}
