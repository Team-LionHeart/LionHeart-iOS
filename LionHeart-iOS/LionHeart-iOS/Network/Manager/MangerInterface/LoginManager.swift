//
//  LoginManager.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol LoginManager {
    func login(type: LoginType, kakaoToken: String) async throws
}
