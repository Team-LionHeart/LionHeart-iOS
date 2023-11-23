//
//  ArticleCategortFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import Foundation

struct ArticleCategortFactoryImpl: ArticleCategortFactory {
    
    
    func makeArticleListByCategoryViewModel(cooridnator: ArticleCategoryCoordinator) -> any ArticleListByCategoryViewModel & ArticleListByCategoryViewModelPresentable {
        let adaptor = self.makeArticleCategoryAdaptor(coordinator: cooridnator)
        
        let apiService = APIService()
        let bookmarkServiceImpl = BookmarkServiceImpl(apiService: apiService)
        let articleServiceImpl = ArticleServiceImpl(apiService: apiService)
        let manager = ArticleListByCategoryMangerImpl(articleService: articleServiceImpl, bookmarkService: bookmarkServiceImpl)
     
        return ArticleListByCategoryViewModelImpl(navigator: adaptor, manager: manager)
    }
    
    func makeArticleCategoryViewModel(cooridnator: ArticleCategoryCoordinator) -> any ArticleCategoryViewModel & ArticleCategoryViewModelPresentable {
        let adaptor = self.makeArticleCategoryAdaptor(coordinator: cooridnator)
        return ArticleCategoryViewModelImpl(navigator: adaptor)
    }
    
    func makeArticleCategoryAdaptor(coordinator: ArticleCategoryCoordinator) -> EntireArticleCategoryNavigation {
        return ArticleCategoryAdaptor(coordinator: coordinator)
    }
    
    func makeArticleListByCategoryViewController(coordinator: ArticleCategoryCoordinator, categoryName: String) -> ArticleListByCategoryViewControllerable {
        let viewModel = self.makeArticleListByCategoryViewModel(cooridnator: coordinator)
        viewModel.setCategoryTitle(title: categoryName)
        return ArticleListByCategoryViewController(viewModel: viewModel)
    }
    
    func makeArticleCategoryViewController(coordinator: ArticleCategoryCoordinator) -> ArticleCategoryViewControllerable {
        let viewModel = self.makeArticleCategoryViewModel(cooridnator: coordinator)
        return ArticleCategoryViewController(viewModel: viewModel)
    }
}
