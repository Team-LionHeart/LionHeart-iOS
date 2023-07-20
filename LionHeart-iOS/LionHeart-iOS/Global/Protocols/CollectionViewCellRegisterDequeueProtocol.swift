//
//  CollectionViewCellRegisterDequeueProtocol.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//

import UIKit

protocol CollectionViewCellRegisterDequeueProtocol where Self: UICollectionViewCell {
//    associatedtype T: AppData
    static func register(to collectionView: UICollectionView)
    static func dequeueReusableCell(to collectionView: UICollectionView, indexPath: IndexPath) -> Self
    static var reuseIdentifier: String { get }
//    var inputData: T? { get set }
}


extension CollectionViewCellRegisterDequeueProtocol {
    static func register(to collectionView: UICollectionView) {
        collectionView.register(self, forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    
    static func dequeueReusableCell(to collectionView: UICollectionView, indexPath: IndexPath) -> Self {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? Self else { fatalError()}
        return cell
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
