//
//  MyPageControllerable.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import UIKit

protocol MyPageControllerable where Self: UIViewController {
    var adaptor: MyPageNavigation { get set }
}
