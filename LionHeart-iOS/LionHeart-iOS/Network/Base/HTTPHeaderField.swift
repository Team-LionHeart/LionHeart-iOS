//
//  HTTPHeaderField.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/05.
//

import Foundation

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

enum ContentType: String {
    case json = "Application/json"
}
