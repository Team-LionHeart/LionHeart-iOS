//
//  LoginViewControllerable.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

protocol ViewModel where Self: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

protocol LoginViewModelPresentable {
    var navigator: LoginNavigation { get set } // Coordinator
}
