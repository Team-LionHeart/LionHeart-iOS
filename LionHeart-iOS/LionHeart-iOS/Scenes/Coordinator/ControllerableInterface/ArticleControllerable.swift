//
//  ArticleControllerable.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import UIKit


protocol ArticleControllerable where Self: UIViewController {
    func setArticleId(id: Int?)
    var adaptor: ArticleDetailModalNavigation { get set }
}
