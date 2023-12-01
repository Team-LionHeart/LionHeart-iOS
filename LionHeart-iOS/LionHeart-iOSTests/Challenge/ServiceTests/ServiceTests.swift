//
//  ServiceTests.swift
//  LionHeart-iOSTests
//
//  Created by 김의성 on 12/01/23.
//

import XCTest
@testable import FirebaseMessaging
@testable import LionHeart_iOS

final class ServiceTests: XCTestCase {
    
    var apiService: Requestable!
    var urlSession: URLSessionStub!
    var jsonLoader: JSONLoader!
    var data: Data!
    var url: URL!

    override func setUpWithError() throws {
        self.jsonLoader = JSONLoader()
        self.url = URL(string: "https://api/v1/challenge/progress")
    }

    override func tearDownWithError() throws {
        self.jsonLoader = nil
        self.url = nil
    }

    func test_챌린지API_호출이_잘되는지() async throws {
        //given
        let url = jsonLoader.load(fileName: "ChallengeSuccessJson")
        self.data = try Data(contentsOf: url)
        self.urlSession = URLSessionStub(data: self.data)
        self.apiService = APIService(session: urlSession)
        
        //when
        let urlRequest = URLRequest(url: self.url)
        guard let result: ChallengeDataResponse = try await self.apiService.request(urlRequest) else {
            return XCTFail()
        }
        
        //then
        let expectation = ChallengeDataResponse(babyNickname: "Test닉네임", day: 10, level: "LEVEL_ONE", attendances: ["11/1","11/2","11/3"])
        XCTAssertEqual(result.babyNickname, expectation.babyNickname)
        XCTAssertEqual(result.day, expectation.day)
        XCTAssertEqual(result.attendances.count, expectation.attendances.count)
    }
}
