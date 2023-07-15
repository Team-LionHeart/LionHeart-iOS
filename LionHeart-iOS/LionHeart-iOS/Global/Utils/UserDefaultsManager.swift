//
//  UserDefaultsManager.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/14.
//

import Foundation

@propertyWrapper
/// UserDefault에 set하고 load해오기 위한 Manager
struct UserDefaultsWrapper<T: Codable> {

    private let key: String
    private let defaultValue: T?

    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T? {
        get {
            guard let loadedData = UserDefaults.standard.object(forKey: UserDefaultKey.token) as? Data,
                  let decodedObject = try? JSONDecoder().decode(T.self, from: loadedData)
            else { return defaultValue }
            return decodedObject
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: UserDefaultKey.token)
            }

        }
    }

}

struct UserDefaultsManager {
    @UserDefaultsWrapper(key: UserDefaultKey.token, defaultValue: nil)
    static var tokenKey: Token?
}
