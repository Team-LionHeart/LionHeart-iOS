//
//  CurriculumFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation


struct CurriculumFactoryImpl: CurriculumFactory {
    func makeCurriculumListViewController() -> CurriculumArticleByWeekControllerable {
        let apiService = APIService()
        let curriculumService = CurriculumServiceImpl(apiService: apiService)
        let bookmarkService = BookmarkServiceImpl(apiService: apiService)
        let curriculumListManager = CurriculumListManagerImpl(bookmarkService: bookmarkService, curriculumService: curriculumService)
        let curriculumListViewController = CurriculumListByWeekViewController(manager: curriculumListManager)
        return curriculumListViewController
    }
    
    func makeCurriculumViewController() -> CurriculumControllerable {
        let apiService = APIService()
        let curriculumService = CurriculumServiceImpl(apiService: apiService)
        let manager = CurriculumManagerImpl(curriculumService: curriculumService)
        let curriculumViewController = CurriculumViewController(manager: manager)
        return curriculumViewController
    }
    
    
}
