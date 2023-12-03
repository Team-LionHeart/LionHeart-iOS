//
//  NetworkError.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/11.
//

import Foundation

@frozen
enum NetworkError: Error, CustomStringConvertible, Equatable {
    case urlEncodingError
    case jsonDecodingError
    case badCasting
    case fetchImageError
    case unAuthorizedError
    case clientError(code: String, message: String)
    case serverError
    
    var description: String {
        switch self {
        case .urlEncodingError:
            return "🔒URL Encoding 에러입니다"
        case .jsonDecodingError:
            return "🔐JSON Decoding 에러입니다"
        case .badCasting:
            return "❌잘못된 타입 캐스팅입니다 (HTTPResponse)"
        case .fetchImageError:
            return "🌄Image URL로부터 불러오기 실패"
        case .unAuthorizedError:
            return "🚪 접근 권한이 없습니다 (토큰 만료)"
        case .clientError(let code, let message):
            return "📱클라이언트 에러 code: \(code), message:\(message)"
        case .serverError:
            return "🖥️서버 에러"
        }
    }
}
