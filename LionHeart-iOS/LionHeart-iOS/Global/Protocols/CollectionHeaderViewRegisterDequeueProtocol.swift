//
//  CollectionHeaderViewRegisterDequeueProtocol.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/14.
//

import UIKit

protocol CollectionSectionViewRegisterDequeueProtocol where Self: UICollectionReusableView {
//    associatedtype T: AppData
    static func registerHeaderView(to collectionView: UICollectionView)
    static func registerFooterView(to collectionView: UICollectionView)
    static func dequeueReusableheaderView(to collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, indexPath: IndexPath) -> Self
    static func dequeueReusablefooterView(to collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, indexPath: IndexPath) -> Self
    static var reuseIdentifier: String { get }
//    var inputData: T? { get set }
}

extension CollectionSectionViewRegisterDequeueProtocol {
    static func registerHeaderView(to collectionView: UICollectionView) {
        collectionView.register(self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.reuseIdentifier)
    }
    
    static func registerFooterView(to collectionView: UICollectionView) {
        collectionView.register(self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self.reuseIdentifier)
    }
    
    static func dequeueReusableheaderView(to collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, indexPath: IndexPath) -> Self {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? Self else { fatalError("Error! \(self.reuseIdentifier)") }
        return headerView
    }
    
    static func dequeueReusablefooterView(to collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, indexPath: IndexPath) -> Self {
        guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? Self else { fatalError("Error! \(self.reuseIdentifier)") }
        return footerView
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
