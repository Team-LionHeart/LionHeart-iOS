//
//  HTTPMethod.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/13.
//

import UIKit

enum HttpMethod: String {
    case `get`
    case post
    case put
    case patch
    case delete

    var rawValue: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        }
    }
}
