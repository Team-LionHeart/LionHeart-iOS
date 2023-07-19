//
//  ChallengeService.swift
//  LionHeart-iOS
//
//  Created by 김동현 on 2023/07/19.
//

import Foundation

final class ChallengeService: Serviceable {
    static let shared = ChallengeService()
    private init() {}

    func inquireChallengeInfo() async throws -> ChallengeData{
        let urlRequest = try NetworkRequest(path: "/v1/challenge/progress", httpMethod: .get)
            .makeURLRequest(isLogined: true)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)
     
        guard  let model = try handleErrorCode(data: data, decodeType: ChallengeDataResponse.self) else { return ChallengeData(babyDaddyName: "", howLongDay: 0, daddyLevel: "", daddyAttendances: []) }
        
        return ChallengeData(babyDaddyName: model.babyNickname, howLongDay: model.day, daddyLevel: model.level, daddyAttendances: model.attendances)
    }
}
