//
//  URLSessionStub.swift
//  LionHeart-iOSTests
//
//  Created by 김민재 on 11/28/23.
//

import Foundation
@testable import LionHeart_iOS

final class URLSessionStub: LHURLSession {
    
    private var data: Data?
    
    init(data: Data? = nil) {
        self.data = data
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return (data ?? Data(), URLResponse())
    }
}
