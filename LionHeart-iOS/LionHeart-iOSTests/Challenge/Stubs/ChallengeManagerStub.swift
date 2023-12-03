//
//  ChallengeManagerStub.swift
//  LionHeart-iOSTests
//
//  Created by uiskim on 2023/12/01.
//

import Foundation
@testable import LionHeart_iOS

final class ChallengeManagerStub: ChallengeManager {
    var returnValue: ChallengeDataResponse?
    
    func inquireChallengeInfo() async throws -> LionHeart_iOS.ChallengeData {
        guard let returnValue else { throw NetworkError.badCasting }
        return returnValue.toAppData()
    }
}
