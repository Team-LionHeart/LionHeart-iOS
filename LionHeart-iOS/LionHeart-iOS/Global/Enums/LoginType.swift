//
//  LoginType.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/17.
//

import Foundation

enum LoginType {
    case kakao
    case apple
    
    var raw: String {
        return "\(self)".uppercased()
    }
}
