//
//  ViewControllerable.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import UIKit


protocol ViewControllerable where Self: UIViewController {
    var coordinator: Coordinator { get set }
}

