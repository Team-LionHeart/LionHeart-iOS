//
//  NSObject+.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/12.
//

import Foundation


extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
