//
//  MyPageFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation

struct MyPageFactoryImpl: MyPageFactory {
    func makeAdaptor(coordinator: MyPageCoordinator) -> EntireMyPageNavigation {
        return MyPageAdaptor(coordindator: coordinator)
    }
    
    func makeMyPageViewController(coordinator: MyPageCoordinator) -> MyPageControllerable {
        let adaptor = self.makeAdaptor(coordinator: coordinator)
        let apiService = APIService()
        let authService = AuthServiceImpl(apiService: apiService)
        let myPageService = MyPageServiceImpl(apiService: apiService)
        let manager = MyPageManagerImpl(mypageService: myPageService, authService: authService)
        let myPageViewController = MyPageViewController(manager: manager, adaptor: adaptor)
        return myPageViewController
    }
}
