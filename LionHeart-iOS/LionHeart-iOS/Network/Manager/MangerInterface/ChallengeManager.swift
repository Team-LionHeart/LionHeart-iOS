//
//  ChallengeManager.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol ChallengeManager {
    func inquireChallengeInfo() async throws -> ChallengeData
}
