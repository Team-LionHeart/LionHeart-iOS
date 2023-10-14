//
//  MyPageManager.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol MyPageManager {
    func getMyPage() async throws -> BadgeProfileAppData
    func resignUser() async throws
    func logout(token: UserDefaultToken) async throws
}
