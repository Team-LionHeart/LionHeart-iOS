//
//  BookmarkFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

struct BookmarkFactoryImpl: BookmarkFactory {
    func makeBookmarkViewModel(coordinator: BookmarkCoordinator) -> any BookmarkViewModel & BookmarkViewModelPresentable {
        let adaptor = self.makeAdaptor(coordinator: coordinator)
        let apiService = APIService()
        let serviceImpl = BookmarkServiceImpl(apiService: apiService)
        let managerImpl = BookmarkMangerImpl(bookmarkService: serviceImpl)
        return BookmarkViewModelImpl(navigator: adaptor, manager: managerImpl)
    }
    
    func makeAdaptor(coordinator: BookmarkCoordinator) -> EntireBookmarkNavigation {
        let adaptor = BookmarkAdaptor(coordinator: coordinator)
        return adaptor
    }
    
    func makeBookmarkViewController(coordinator: BookmarkCoordinator) -> BookmarkViewControllerable {
        let viewModel = self.makeBookmarkViewModel(coordinator: coordinator)
        return BookmarkViewController(viewModel: viewModel)
    }
}
