//
//  Config.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/07.
//

import Foundation

enum Config {

    enum Keys {
        enum Plist {
            static let kakaoNativeAppKey = "KAKAO_NATIVE_APP_KEY"
        }
    }

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found !!!")
        }
        return dict
    }()
}


extension Config {
    static let kakaoNativeAppKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.kakaoNativeAppKey] as? String else {
            fatalError("KAKAO_NATIVE_APP_KEY is not set in plist for this configuration")
        }
        return key
    }()
}
