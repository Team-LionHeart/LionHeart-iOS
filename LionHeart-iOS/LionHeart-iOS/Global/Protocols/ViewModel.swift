//
//  ViewModel.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/19.
//

import UIKit

protocol ViewModel where Self: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
