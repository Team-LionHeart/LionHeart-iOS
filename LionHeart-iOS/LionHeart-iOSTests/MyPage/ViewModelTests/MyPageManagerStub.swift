//
//  MyPageManagerStub.swift
//  LionHeart-iOSTests
//
//  Created by 황찬미 on 2023/12/03.
//

import Foundation

@testable import LionHeart_iOS

final class MyPageManagerStub: MyPageManager {
    
    var appData: BadgeProfileAppData?
    var canResign = false
    
    func getMyPage() async throws -> LionHeart_iOS.BadgeProfileAppData {
        guard let appData = appData else { throw NetworkError.badCasting }
        return appData
    }
    
    func resignUser() async throws {
        guard canResign else { throw NetworkError.clientError(code: "V001", message: "탈퇴실패")}
    }
    
    func logout(token: LionHeart_iOS.UserDefaultToken) async throws {
        print("로그아웃 성공")
    }
}
