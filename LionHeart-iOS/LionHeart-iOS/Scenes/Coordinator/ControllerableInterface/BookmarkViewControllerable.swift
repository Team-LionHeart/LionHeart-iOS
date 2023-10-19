//
//  BookmarkViewControllerable.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

protocol BookmarkViewControllerable where Self: UIViewController {
    var navigator: BookmarkNavigation { get set }
}
