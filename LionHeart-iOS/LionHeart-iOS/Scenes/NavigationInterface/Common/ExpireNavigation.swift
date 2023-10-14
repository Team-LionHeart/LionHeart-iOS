//
//  ExpireNavigation.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

protocol ExpireNavigation: AnyObject {
    func checkTokenIsExpired()
}

extension ExpireNavigation where Self: Coordinator {
    func checkTokenIsExpired() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}
