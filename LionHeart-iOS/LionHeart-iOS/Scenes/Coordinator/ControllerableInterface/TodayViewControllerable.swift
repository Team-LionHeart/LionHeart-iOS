//
//  TodayViewControllerable.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

protocol TodayViewControllerable where Self: UIViewController {
    var coordinator: TodayNavigation? { get set }
}
