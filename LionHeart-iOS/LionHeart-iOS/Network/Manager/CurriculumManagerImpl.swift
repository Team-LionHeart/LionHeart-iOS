//
//  CurriculumManagerImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/24.
//

import Foundation

final class CurriculumManagerImpl: CurriculumManager {
    
    private let curriculumService: CurriculumService
    
    init(curriculumService: CurriculumService) {
        self.curriculumService = curriculumService
    }
    
    func getCurriculumServiceInfo() async throws -> UserInfoData {
        guard let model = try await curriculumService.getCurriculumServiceInfo() else { throw NetworkError.badCasting }
        return UserInfoData(userWeekInfo: model.week, userDayInfo: model.day, progress: model.progress + 1, remainingDay: model.remainingDay)
    }
}
