//
//  JSONLoader.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 11/28/23.
//

import Foundation

final class JSONLoader {

    func load(fileName: String) -> URL {
        let bundle = Bundle(for: Self.self)
        guard let fileURL = bundle.url(forResource: fileName, withExtension: "json") else {
            return URL(fileURLWithPath: "")
        }
        return fileURL
    }
}
