//
//  TestingAppDelegate.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 12/1/23.
//

import UIKit
import Firebase
import FirebaseMessaging

@objc(TestingAppDelegate)
class TestingAppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        print("Test app delegate")
        
        return true
    }
}
