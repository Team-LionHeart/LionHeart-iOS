//
//  BaseResponse.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/05.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: T?
}
