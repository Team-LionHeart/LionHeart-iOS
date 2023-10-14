//
//  CurriculumManager.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol CurriculumManager {
    func getCurriculumServiceInfo() async throws -> UserInfoData
}
