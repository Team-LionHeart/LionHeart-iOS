//
//  ChallengeService.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/19.
//

import Foundation

final class ChallengeService: ChallengeServiceProtocol {
    
    private let challengeAPIService: ChallengeServiceAPIProtocol
    
    init(challengeAPIService: ChallengeServiceAPIProtocol) {
        self.challengeAPIService = challengeAPIService
    }

    func inquireChallengeInfo() async throws -> ChallengeData{
        guard let model = try await challengeAPIService.inquireChallengeInfo() else { return ChallengeData.empty }
        return toAppData(from: model)
    }
}

extension ChallengeService {
    func toAppData(from input: ChallengeDataResponse) -> ChallengeData {
        return .init(babyDaddyName: input.babyNickname, howLongDay: input.day, daddyLevel: input.level, daddyAttendances: input.attendances)
    }
}
