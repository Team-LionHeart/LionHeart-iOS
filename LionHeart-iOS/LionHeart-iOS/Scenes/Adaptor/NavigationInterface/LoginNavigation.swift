//
//  LoginNavigation.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/14.
//

import Foundation

protocol LoginNavigation: AnyObject {
    func checkUserIsVerified(userState: UserState, kakaoToken: String?)
}
