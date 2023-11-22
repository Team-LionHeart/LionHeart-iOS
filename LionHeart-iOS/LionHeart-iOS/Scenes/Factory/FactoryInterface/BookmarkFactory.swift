//
//  BookmarkFactory.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

protocol BookmarkFactory {
    func makeAdaptor(coordinator: BookmarkCoordinator) -> EntireBookmarkNavigation
    func makeBookmarkViewController(coordinator: BookmarkCoordinator) -> BookmarkViewControllerable
    func makeBookmarkViewModel(coordinator: BookmarkCoordinator) -> any BookmarkViewModel & BookmarkViewModelPresentable
}
