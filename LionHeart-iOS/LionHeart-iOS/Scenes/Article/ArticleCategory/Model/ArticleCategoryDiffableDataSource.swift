//
//  ArticleCategoryDiffableDataSource.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/20/23.
//

import UIKit


final class ArticleCategoryDiffableDataSource: UICollectionViewDiffableDataSource<ArticleCategorySection, ArticleCategoryItem> {
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .category(let title):
                let cell = ArticleCategoryCollectionViewCell.dequeueReusableCell(to: collectionView, indexPath: indexPath)
                cell.inputData = title
                return cell
            }
        }
    }
    
}
