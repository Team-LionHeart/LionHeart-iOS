//
//  BaseResponse.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/05.
//

import Foundation

struct BaseResponse<T: Response>: Response {
    let code: String
    let message: String
    let data: T?
}
