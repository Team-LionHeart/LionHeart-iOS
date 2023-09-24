//
//  MyPageManagerImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

final class MyPageManagerImpl: MyPageManager {
    
    private let mypageService: MypageService
    private let authService: AuthUserOutService
    
    init(mypageService: MypageService, authService: AuthUserOutService) {
        self.mypageService = mypageService
        self.authService = authService
    }
    
    func getMyPage() async throws -> MyPageAppData {
        guard let model = try await mypageService.getMyPage() else { throw NetworkError.badCasting }
        return MyPageAppData(badgeImage: model.level, nickname: model.babyNickname, isAlarm: model.notificationStatus)
    }
    
    func resignUser() async throws {
        try await authService.resignUser()
    }
    
    func logout(token: UserDefaultToken) async throws {
        try await authService.logout(token: token)
    }
}
