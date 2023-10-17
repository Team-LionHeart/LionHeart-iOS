//
//  CurriculumFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation


struct CurriculumFactoryImpl: CurriculumFactory {
    func makeCurriculumListViewController(adaptor: CurriculumListByWeekNavigation) -> CurriculumArticleByWeekControllerable {
        let apiService = APIService()
        let curriculumService = CurriculumServiceImpl(apiService: apiService)
        let bookmarkService = BookmarkServiceImpl(apiService: apiService)
        let curriculumListManager = CurriculumListManagerImpl(bookmarkService: bookmarkService, curriculumService: curriculumService)
        let curriculumListViewController = CurriculumListByWeekViewController(manager: curriculumListManager, navigator: adaptor)
        return curriculumListViewController
    }
    
    func makeCurriculumViewController(adaptor: CurriculumNavigation) -> CurriculumControllerable {
        let apiService = APIService()
        let curriculumService = CurriculumServiceImpl(apiService: apiService)
        let manager = CurriculumManagerImpl(curriculumService: curriculumService)
        let curriculumViewController = CurriculumViewController(manager: manager, adaptor: adaptor)
        return curriculumViewController
    }
    
    
}
