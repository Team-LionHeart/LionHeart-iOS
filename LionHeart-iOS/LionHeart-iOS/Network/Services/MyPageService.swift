//
//  MyPageService.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/21.
//

import UIKit

protocol MyPageServiceProtocol: AnyObject {
    func getMyPage() async throws -> MyPageAppData
    func resignUser() async throws
    func logout(token: UserDefaultToken) async throws
}
