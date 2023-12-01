//
//  main.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 12/1/23.
//

import UIKit
import Firebase
import FirebaseMessaging

let appDelegateClass: AnyClass = NSClassFromString("TestingAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc,
                  CommandLine.unsafeArgv,
                  nil,
                  NSStringFromClass(appDelegateClass))
