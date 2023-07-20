//
//  MyPageService.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/21.
//

import UIKit

final class MyPageService: Serviceable {
    static let shared = MyPageService()
    private init() { }
    
    func getMyPage() async throws -> MyPageAppData {
        let urlRequest = try NetworkRequest(path: "/v1/member/profile", httpMethod: .get).makeURLRequest(isLogined: true)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: MyPageResponse.self)
        guard let model else { return .init(badgeImage: "", nickname: "", isAlarm: "") }
        return MyPageAppData(badgeImage: model.level,
                             nickname: model.babyNickname,
                             isAlarm: model.notificationStatus)
    }
}
