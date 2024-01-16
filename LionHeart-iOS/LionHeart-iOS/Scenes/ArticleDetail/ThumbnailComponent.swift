//
//  ThumbnailComponent.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 1/16/24.
//

import UIKit
import Carbon


struct ThumbnailComponent: IdentifiableComponent {
    
    var model: ArticleBlockData
    
    var onSelect: (() -> Void)
    
    var id: String {
        ThumbnailContent.className
    }
    
    func renderContent() -> ThumbnailContent {
        return .init()
    }
    
    func render(in content: ThumbnailContent) {
        content.onSelect = onSelect
        content.configureCell(model)
    }
    
    func contentDidEndDisplay(_ content: ThumbnailContent) {
        content.thumbnailImageView.image = nil
    }
}
