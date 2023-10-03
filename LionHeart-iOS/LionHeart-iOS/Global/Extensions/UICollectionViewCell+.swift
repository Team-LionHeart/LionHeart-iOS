//
//  UICollectionViewCell+.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/04.
//

import UIKit

extension UICollectionViewCell {
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UICollectionView else { return nil }
        return superView.indexPath(for: self)
    }
}
