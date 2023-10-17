//
//  LoginViewControllerable.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

protocol LoginViewControllerable where Self: UIViewController {
    var navigator: LoginNavigation { get set }
}
