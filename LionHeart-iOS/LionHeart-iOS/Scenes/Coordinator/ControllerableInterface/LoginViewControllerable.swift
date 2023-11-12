//
//  LoginViewControllerable.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

//protocol LoginViewControllerable where Self: UIViewController {
//    var navigator: LoginNavigation { get set }
//}

protocol ViewModel where Self: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

protocol LoginViewModelPresentable { // ViewModel Property를 설정해준다.
    var navigator: LoginNavigation { get set } // Coordinator
    
//    func setAricleId(_ id: Int) // Factory return type
}
