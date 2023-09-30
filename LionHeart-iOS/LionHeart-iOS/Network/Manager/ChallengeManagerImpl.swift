//
//  ChallengeManagerImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

final class ChallengeManagerImpl: ChallengeManager {
    
    private let challengeService: ChallengeService
    
    init(challengeService: ChallengeService) {
        self.challengeService = challengeService
    }
    
    func inquireChallengeInfo() async throws -> ChallengeData {
        guard let model = try await challengeService.inquireChallengeInfo() else { return .empty }
        return model.toAppData()
    }
}
